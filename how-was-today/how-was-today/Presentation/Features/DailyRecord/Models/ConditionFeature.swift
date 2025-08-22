//
//  ConditionFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import SwiftUI

struct ConditionFeature: DailyRecordFeature {
    var id = DailyRecordType.condition
    
    var title: String = "몸 상태"
    
    var systemImageName: String = "figure.child"
    
    var imageColor: Color = Color.health
    
    func getRoute(date: Date) -> HowWasTodayRouter.Route? {
        .condition(date: date)
    }
}

enum ConditionType: String, CaseIterable, Identifiable {
    
    case good, bad, soso
    
    var title: String {
        switch self {
        case .good:
            return "👍좋아요"
        case .bad:
            return "😣불편해요"
        case .soso:
            return "😐괜찮아요"
        }
    }
    
    var id: String { return self.rawValue }
}

struct ConditionOption: Identifiable, Hashable {
    let id: String
    let category: ConditionType
    let titleKey: String
    let icon: String?              // SF Symbol 이름
}

enum ConditionCatalog {
    // 전역 인덱스: id -> ConditionOption
    static let indexById: [String: ConditionOption] = {
        ConditionType.allCases
            .flatMap { options(for: $0) }
            .reduce(into: [:]) { $0[$1.id] = $1 }
    }()

    // 편의 조회
    static func option(for id: String) -> ConditionOption? {
        indexById[id]
    }
    
    static func options(for type: ConditionType) -> [ConditionOption] {
        switch type {
        case .good:
            return [
                make(type, "good_fresh", "상쾌해요", "sun.max"),
                make(type, "good_light", "가벼워요", "balloon.fill"),
                make(type, "good_energy", "활력이 있어요", "bolt"),
                make(type, "good_skin", "피부가 좋아요", "face.smiling"),
                make(type, "good_digest", "소화가 잘 돼요", "fork.knife"),
                make(type, "good_sleep", "숙면했어요", "bed.double"),
                make(type, "good_no_pain", "통증 없어요", "checkmark.circle")
            ]

        case .bad:
            return [
                make(type, "bad_headache", "두통 있어요", "brain.head.profile"),
                make(type, "bad_stomach", "복통 있어요", "stethoscope"),
                make(type, "bad_back", "허리 아파요", "figure.walk"),
                make(type, "bad_muscle", "근육통 있어요", "dumbbell"),
                make(type, "bad_dizzy", "어지러워요", "circle.dashed"),
                make(type, "bad_numb", "손발 저려요", "hand.point.up"),
                make(type, "bad_skin", "피부 트러블 있어요", "bandage"),
                make(type, "bad_constipation", "변비/설사 있어요", "exclamationmark.triangle"),
                make(type, "bad_bloated", "속이 더부룩해요", "wind")
            ]

        case .soso:
            return [
                make(type, "soso_normal", "보통이에요", "circle"),
                make(type, "soso_no_change", "별다른 변화 없어요", "ellipsis"),
                make(type, "soso_drowsy", "나른해요", "zzz"),
                make(type, "soso_tired", "조금 피곤해요", "tortoise"),
                make(type, "soso_calm", "평온해요", "leaf")
            ]
        }
    }

    private static func make(_ type: ConditionType,
                             _ id: String,
                             _ title: String,
                             _ icon: String?) -> ConditionOption {
        ConditionOption(
            id: id,
            category: type,
            titleKey: title,
            icon: icon
        )
    }

    static var all: [ConditionType: [ConditionOption]] {
        Dictionary(uniqueKeysWithValues: ConditionType.allCases.map { type in
            (type, options(for: type))
        })
    }
}
