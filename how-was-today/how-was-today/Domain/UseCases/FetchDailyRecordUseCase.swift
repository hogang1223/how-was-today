//
//  FetchDailyRecordUseCase.swift
//  how-was-today
//
//  Created by stocktong on 8/19/25.
//

import Foundation

protocol FetchDailyRecordUseCase {
    func refresh(date: Date)
    func fetch(date: Date) -> DailyRecord
}

struct FetchDailyRecordUseCaseImpl: FetchDailyRecordUseCase {
    
    private let weightStore: WeightStore
    private let moodStore: MoodStore
    private let conditionStore: ConditionStore
    
    init(
        weightStore: WeightStore,
        moodStore: MoodStore,
        conditionStore: ConditionStore
    ) {
        self.weightStore = weightStore
        self.moodStore = moodStore
        self.conditionStore = conditionStore
    }
    
    func refresh(date: Date) {
        weightStore.refresh(date: date)
        moodStore.refresh(date: date)
        conditionStore.refresh(date: date)
    }
    
    func fetch(date: Date) -> DailyRecord {
        var record = DailyRecord(date: date)
        if let weight = weightStore.item(on: date) {
            record.weight = String(format: "%.1f", weight)
        }
        record.mood = moodStore.item(on: date)?.rawValue
        
        if let opts = conditionStore.item(on: date) {
            let titles = opts.map { $0.titleKey }
            let condition = titles.joined(separator: ", ")
            record.condition = condition
        }
        return record
    }
}
