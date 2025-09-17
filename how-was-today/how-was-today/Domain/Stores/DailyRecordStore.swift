//
//  DailyRecordStore.swift
//  how-was-today
//
//  Created by hogang on 8/20/25.
//

import Foundation

/// 일일 기록 저장소
/// prefetch (Month)
/// 특정일자 fetch
/// 특정일자 새로 불러오기 > 1개
/// 저장 > 1개씩
/// 삭제 > 1개씩
/// 조회 > 1개씩
final class DailyRecordStore {
    
    private var recordsByDate: [String: DailyRecord] = [:]
    
    private let weightRepo: DailyWeightLogRepository
    private let moodRepo: DailyMoodLogRepository
    private let memoRepo: DailyMemoLogRepository
    private let conditionRepo: DailyConditionLogRepository
    
    init(weightRepo: DailyWeightLogRepository,
         moodRepo: DailyMoodLogRepository,
         memoRepo: DailyMemoLogRepository,
         conditionRepo: DailyConditionLogRepository) {
        self.weightRepo = weightRepo
        self.moodRepo = moodRepo
        self.memoRepo = memoRepo
        self.conditionRepo = conditionRepo
    }
    
    func prefetchMonthRecords(for: Date) {
    }
    
    func refresh(date: Date) {}
    
}

// MARK: - Old Version

protocol OldDailyRecordStore {
    associatedtype T
    
    var itemByDate: [String: T] { get set }
    
    func refresh(date: Date)
    func item(on date: Date) -> T?
    func save(_ item: T, on date: Date)
    func delete(on date: Date)
    func key(from date: Date) -> String
}

extension OldDailyRecordStore {
    
    func item(on date: Date) -> T? {
        itemByDate[key(from: date)]
    }
    
    func delete(on date: Date) {}
    
    func key(from date: Date) -> String {
        date.toString(format: DailyRecord.dateFormat)
    }
}
