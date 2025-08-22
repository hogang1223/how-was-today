//
//  ConditionRecordViewModel.swift
//  how-was-today
//
//  Created by hogang on 8/20/25.
//

import Foundation

final class ConditionRecordViewModel<Store: DailyRecordStore>: ObservableObject where Store.T == [ConditionOption] {
    
    @Published var options: Set<ConditionOption> = []
    private let date: Date
    private let store: Store
    
    var disableReset: Bool {
        options.isEmpty
    }
    
    init(date: Date, store: Store) {
        self.date = date
        self.store = store
    }
    
    func reset() {
        options = []
    }
    
    func refresh() {
        store.refresh(date: date)
        fetch()
    }
    
    func fetch() {
        options = Set(store.item(on: date) ?? [])
    }
    
    func save() {
        guard !options.isEmpty else {
            delete()
            return
        }
        
        let all = ConditionType.allCases.map { ConditionCatalog.options(for: $0) }.flatMap { $0 }
        let sorted = all.filter { options.contains($0) }
        store.save(sorted, on: date)
    }
    
    func delete() {
        store.delete(on: date)
    }
    
    func toggle(_ option: ConditionOption) {
        if options.contains(option) {
            options.remove(option)
        } else {
            options.insert(option)
        }
    }
}
