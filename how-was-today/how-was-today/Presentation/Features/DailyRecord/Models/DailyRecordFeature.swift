//
//  DailyRecordFeature.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//
import SwiftUI

protocol DailyRecordFeature: Identifiable {
    var id: DailyRecordType { get }
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
