//
//  DailyMemoLogRepository.swift
//  how-was-today
//
//  Created by stocktong on 8/22/25.
//

import Foundation

protocol DailyMemoLogRepository {
    func fetchMemo(on date: Date) -> String?
    func saveMemo(on date: Date, _ memo: String) throws
    func deleteMemo(on date: Date) throws
}

final class DailyMemoLogRepositoryImpl<Storage: DataStorage>: DailyMemoLogRepository
where Storage.ObjectType == DailyMemoLog {

    private let storage: Storage
    init(storage: Storage) { self.storage = storage }
    
    func fetchMemo(on date: Date) -> String? {
        let id = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", id)
        let one = try? storage.fetch(predicate: p, sortDescriptors: nil)?.first
        return one?.memo
    }
    
    func saveMemo(on date: Date, _ memo: String) throws {
        let id = date.toString(format: DailyRecord.dateFormat)
        let log = DailyMemoLog()
        log.id = id
        log.date = date
        log.memo = memo
        try storage.save(log)
    }
    
    func deleteMemo(on date: Date) throws {
        let id = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", id)
        try storage.deleteAll(predicate: p)
    }
}
