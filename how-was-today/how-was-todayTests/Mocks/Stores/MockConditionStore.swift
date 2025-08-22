//
//  MockConditionStore.swift
//  how-was-today
//
//  Created by hogang on 8/22/25.
//

import Foundation
@testable import how_was_today

final class MockConditionStore: DailyRecordStore {
    
    typealias T = [ConditionOption]
    
    var itemByDate: [String: [ConditionOption]] = [:]
    
    private(set) var refreshedDates: [Date] = []
    private(set) var saved: [(Date, [ConditionOption])] = []
    private(set) var deletedDates: [Date] = []
    
    func refresh(date: Date) {
        refreshedDates.append(date)
    }
    
    func item(on date: Date) -> [ConditionOption]? {
        itemByDate[key(from: date)]
    }
    
    func save(_ item: [ConditionOption], on date: Date) {
        saved.append((date, item))
        itemByDate[key(from: date)] = item
    }
    
    func delete(on date: Date) {
        deletedDates.append(date)
        itemByDate[key(from: date)] = []
    }
}
