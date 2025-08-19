//
//  DailyRecordFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//
import SwiftUI

enum DailyRecord: String, CaseIterable {
    case weight
    case condition
    case mood
    case memo
    
    static let dateFormat = "yyyy-MM-dd"
    
    static let all: [any DailyRecordFeature] = [
        WeightFeature(),
        ConditionFeature(),
        MoodFeature(),
        MemoFeature()
    ]
}

protocol DailyRecordFeature: Identifiable {
    var id: DailyRecord { get }
    var title: String { get }
    var systemImageName: String { get }
    var imageColor: Color { get }
    
    func getRoute(date: Date) -> HowWasTodayRouter.Route?
    func getModal(date: Date) -> HowWasTodayRouter.Modal?
}

extension DailyRecordFeature {
    func getRoute(date: Date) -> HowWasTodayRouter.Route? {
        nil
    }
    func getModal(date: Date) -> HowWasTodayRouter.Modal? {
        nil
    }
}
