//
//  DailyRecordStore.swift
//  how-was-today
//
//  Created by hogang on 8/20/25.
//

import Foundation

protocol DailyRecordStore {
    associatedtype T
    
    var itemByDate: [String: T] { get set }
    
    func refresh(date: Date)
    func item(on date: Date) -> T?
    func save(_ item: T, on date: Date)
    func delete(on date: Date)
    func key(from date: Date) -> String
    func prefetch(center: Date, daysBefore: Int, daysAfter: Int)
}

extension DailyRecordStore {
    
    func item(on date: Date) -> T? {
        itemByDate[key(from: date)]
    }
    
    func delete(on date: Date) {}
    
    func key(from date: Date) -> String {
        date.toString(format: DailyRecord.dateFormat)
    }
    
    func prefetch(center: Date, daysBefore: Int, daysAfter: Int) {}
}
