//
//  ConditionStore.swift
//  how-was-today
//
//  Created by hogang on 8/20/25.
//

import Foundation

final class ConditionStore: ObservableObject, DailyRecordStore {
    
    typealias T = [ConditionOption]
    
    @Published var itemByDate: [String: T] = [:]
    
    private let repo: DailyConditionLogRepository
    
    init(repo: DailyConditionLogRepository) {
        self.repo = repo
    }
    
    func refresh(date: Date) {
        if let ids = repo.fetchSelectedConditionOptions(on: date) {
            let opts = ids.compactMap {
                ConditionCatalog.option(for: $0)
            }
            itemByDate[key(from: date)] = opts
        }
    }
    
    func save(_ item: T, on date: Date) {
        do {
            let ids = item.compactMap { $0.id }
            try repo.saveConditionOptions(on: date, ids)
            itemByDate[key(from: date)] = item
        } catch {
            print("save condition error \(error.localizedDescription)")
        }
    }
    
    func delete(on date: Date) {
        do {
            try repo.deleteConditionOptions(on: date)
            itemByDate.removeValue(forKey: key(from: date))
        } catch {
            print("delete condition error \(error.localizedDescription)")
        }
    }
}
