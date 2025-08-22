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
    
    init(weightStore: WeightStore, moodStore: MoodStore) {
        self.weightStore = weightStore
        self.moodStore = moodStore
    }
    
    func refresh(date: Date) {
        weightStore.refresh(date: date)
        moodStore.refresh(date: date)
    }
    
    func fetch(date: Date) -> DailyRecord {
        var record = DailyRecord(date: date)
        if let weight = weightStore.item(on: date) {
            record.weight = String(format: "%.1f", weight)
        }
        record.mood = moodStore.item(on: date)?.rawValue
        return record
    }
}
