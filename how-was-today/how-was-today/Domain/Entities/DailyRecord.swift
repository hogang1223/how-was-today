//
//  DailyRecord.swift
//  how-was-today
//
//  Created by stocktong on 8/19/25.
//

import Foundation

enum DailyRecordType: String, CaseIterable {
    case weight
    case condition
    case mood
    case memo
}

struct DailyRecord {
    var date: Date
    var weight: String?
    var condition: String?
    var mood: String?
    var memo: String?
    
    init(date: Date) {
        self.date = date
    }
}

extension DailyRecord {
    static let dateFormat = "yyyy-MM-dd"
    
    static let all: [any DailyRecordFeature] = [
        WeightFeature(),
        ConditionFeature(),
        MoodFeature(),
        MemoFeature()
    ]
}
