//
//  MemoStore.swift
//  how-was-today
//
//  Created by stocktong on 8/22/25.
//

import Foundation

final class MemoStore: ObservableObject, DailyRecordStore {
    
    typealias T = String
    
    @Published var itemByDate: [String: T] = [:]
    
    private let repo: DailyMemoLogRepository
    
    init(repo: DailyMemoLogRepository) {
        self.repo = repo
    }
    
    func refresh(date: Date) {
        if let memo = repo.fetchMemo(on: date) {
            itemByDate[key(from: date)] = memo
        }
    }
    
    func save(_ item: String, on date: Date) {
        do {
            try repo.saveMemo(on: date, item)
            itemByDate[key(from: date)] = item
        } catch {
            print("save memo error \(error.localizedDescription)")
        }
    }
    
    func delete(on date: Date) {
        do {
            try repo.deleteMemo(on: date)
            itemByDate.removeValue(forKey: key(from: date))
        } catch {
            print("delete memo error \(error.localizedDescription)")
        }
    }
    
}
