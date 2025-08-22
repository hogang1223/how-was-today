//
//  WeightStore.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation

final class WeightStore: ObservableObject, DailyRecordStore {
    
    typealias T = Double
    
    let defaultWeight = 50.0
    @Published var itemByDate: [String: Double] = [:]
    
    private let repo: DailyWeightLogRepository
    
    init(repo: DailyWeightLogRepository) {
        self.repo = repo
    }
    
    func refresh(date: Date) {
        if let w = repo.fetchWeight(on: date) {
            itemByDate[key(from: date)] = w
        }
    }
    
    func lastestWeight(date: Date) -> Double? {
        repo.fetchLastestWeight(on: date)
    }
    
    func save(_ weight: Double, on date: Date) {
        do {
            try repo.saveWeight(on: date, weight)
            itemByDate[key(from: date)] = weight
        } catch {
            print("save weight error \(error.localizedDescription)")
        }
    }
    
    func delete(on date: Date) {
        do {
            try repo.deleteWeight(on: date)
            itemByDate.removeValue(forKey: key(from: date))
        } catch {
            print("delete weight error \(error.localizedDescription)")
        }
    }
}
