//
//  DailyConditionLogRepository.swift
//  how-was-today
//
//  Created by hogang on 8/20/25.
//

import Foundation

protocol DailyConditionLogRepository {
    func fetchSelectedConditionOptions(on date: Date) -> [String]?
    func saveConditionOptions(on date: Date, _ values: [String]) throws
    func deleteConditionOptions(on date: Date) throws
}

final class DailyConditionLogRepositoryImpl<Storage: DataStorage>: DailyConditionLogRepository
where Storage.ObjectType == DailyConditionLog {
    
    private let storage: Storage
    init(storage: Storage) { self.storage = storage }
    
    func fetchSelectedConditionOptions(on date: Date) -> [String]? {
        let id = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", id)
        let one = try? storage.fetch(predicate: p, sortDescriptors: nil)?.first
        return one?.selections.map { $0.optionId }
    }
    
    func saveConditionOptions(on date: Date, _ values: [String]) throws {
        let log = DailyConditionLog()
        log.id = date.toString(format: DailyRecord.dateFormat)
        log.date = date
        
        let selections: [DailyConditionSelection] = values.compactMap {
            makeSelection(for: $0)
        }
        log.selections.append(objectsIn: selections)
        try storage.save(log)
    }
    
    func deleteConditionOptions(on date: Date) throws {
        let id = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", id)
        try storage.deleteAll(predicate: p)
    }
    
    private func makeSelection(for id: String) -> DailyConditionSelection? {
        guard let option = ConditionCatalog.option(for: id) else { return nil }
        let selection = DailyConditionSelection()
        selection.optionId = option.id
        selection.category = option.category.rawValue
        return selection
    }
}
