//
//  MoodRecordBottomSheetViewModel.swift
//  how-was-today
//
//  Created by stocktong on 8/18/25.
//

import Foundation

final class MoodRecordBottomSheetViewModel: ObservableObject {
    
    var date: Date
    private let store: MoodStore
    
    init(date: Date, store: MoodStore) {
        self.date = date
        self.store = store
    }
    
    func refresh() {
        store.refresh(date: date)
    }
    
    func fetchMood() -> Mood? {
        store.item(on: date)
    }
    
    func saveMood(_ mood: Mood) {
        store.save(mood, on: date)
    }
    
    func deleteMood() {
        store.delete(on: date)
    }
}
