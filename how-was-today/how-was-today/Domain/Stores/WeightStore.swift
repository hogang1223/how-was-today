//
//  WeightStore.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation

final class WeightStore: ObservableObject {
    
    let defaultWeight = 50.0
    @Published private(set) var weightByDate: [String: Double] = [:]
    
    private let repo: DailyWeightLogRepository
    
    init(repo: DailyWeightLogRepository) {
        self.repo = repo
    }
    
    func refresh(date: Date) {
        if let w = repo.fetchWeight(on: date) {
            weightByDate[id(from: date)] = w
        }
    }
    
    func lastestWeight(date: Date) -> Double? {
        repo.fetchLastestWeight(on: date)
    }
    
    func save(_ weight: Double, on date: Date) {
        do {
            try repo.saveWeight(on: date, weight)
            weightByDate[id(from: date)] = weight
        } catch {
            print("save weight error \(error.localizedDescription)")
        }
    }
    
    func weight(on date: Date) -> Double? {
        weightByDate[id(from: date)]
    }
    
    func delete(on date: Date) {
        do {
            try repo.deleteWeight(on: date)
            weightByDate.removeValue(forKey: id(from: date))
        } catch {
            print("delete weight error \(error.localizedDescription)")
        }
    }
    
    private func id(from date: Date) -> String {
        date.toString(format: DailyRecord.dateFormat)
    }
}
