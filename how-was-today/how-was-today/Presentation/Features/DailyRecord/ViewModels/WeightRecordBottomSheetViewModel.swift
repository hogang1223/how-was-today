//
//  WeightRecordBottomSheetViewModel.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation

final class WeightRecordBottomSheetViewModel: ObservableObject {
    
    private let date: Date
    private let store: WeightStore
    
    init(date: Date, store: WeightStore) {
        self.date = date
        self.store = store
        store.refresh(date: date)
    }
    
    func fetchWeight() -> Double {
        if let weight = store.weight(on: date) {
            return weight
        } else if let lastestWeight = store.lastestWeight(date: date) {
            return lastestWeight
        } else {
            return store.defaultWeight
        }
    }
    
    func saveWeight(_ weight: Double) {
        store.save(weight, on: date)
    }
    
    func hasWeightRecord() -> Bool {
        return store.weight(on: date) != nil
    }
    
    func deleteWeight() {
        store.delete(on: date)
    }
}
