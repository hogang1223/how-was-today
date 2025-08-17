//
//  DailyRecordFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//
import SwiftUI

protocol DailyRecordFeature: Identifiable {
    var id: String { get }
    var title: String { get }
    var systemImageName: String { get }
    var imageColor: Color { get }
    var route: HowWasTodayRouter.Route? { get }
    var modal: HowWasTodayRouter.Modal? { get }
}

enum DailyRecordRegistry {
    static let all: [any DailyRecordFeature] = [
        WeightFeature(),
        ConditionFeature(),
        MoodFeature(),
        MemoFeature()
    ]
}
