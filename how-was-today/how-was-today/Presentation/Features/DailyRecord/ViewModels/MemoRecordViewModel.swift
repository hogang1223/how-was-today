//
//  MemoRecordViewModel.swift
//  how-was-today
//
//  Created by stocktong on 8/20/25.
//

import Foundation

final class MemoRecordViewModel<Store: DailyRecordStore>: ObservableObject where Store.T == String {
    
    let date: Date
    private let store: Store
    
    @Published var memo: String = ""
    private var original: String = ""
    
    var disableReset: Bool {
        memo.isEmpty
    }
    
    init(date: Date, store: Store) {
        self.date = date
        self.store = store
    }
    
    func reset() {
        memo = ""
    }
    
    func refresh() {
        store.refresh(date: date)
        fetch()
    }
    
    func fetch() {
        if let newMemo = store.item(on: date) {
            memo = newMemo
            original = newMemo
        }
    }
    
    func save() {
        guard isMemoChanged() else { return }
        
        let trimmed = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            delete()
        } else {
            store.save(memo, on: date)
        }
    }
    
    func delete() {
        store.delete(on: date)
    }
    
    func isMemoChanged() -> Bool {
        let trimmed = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed != original
    }
}
