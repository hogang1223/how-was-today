//
//  DailyWeightLogRepository.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation

protocol DailyWeightLogRepository {
    func fetchLastestWeight(on date: Date) -> Double?
    func fetchWeight(on date: Date) -> Double?
    func saveWeight(on date: Date, _ weight: Double) throws
    func deleteWeight(on date: Date) throws
}

final class DailyWeightLogRepositoryImpl<Storage: DataStorage>: DailyWeightLogRepository
where Storage.ObjectType == DailyWeightLog {

    private let storage: Storage
    init(storage: Storage) { self.storage = storage }
    
    func fetchLastestWeight(on date: Date) -> Double? {
        let id = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id <= %@", id)
        let sort = [NSSortDescriptor(key: "id", ascending: false)]
        let one = try? storage.fetch(predicate: p, sortDescriptors: sort)?.first
        return one?.weight
    }
    
    func fetchWeight(on date: Date) -> Double? {
        let key = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", key)
        let one = try? storage.fetch(predicate: p, sortDescriptors: nil)?.first
        return one?.weight
    }
    
    func saveWeight(on date: Date, _ weight: Double) throws {
        let key = date.toString(format: DailyRecord.dateFormat)
        let log = DailyWeightLog()
        log.id = key
        log.date = date
        log.weight = weight
        try storage.save(log)
    }
    
    func deleteWeight(on date: Date) throws {
        let key = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", key)
        try storage.deleteAll(predicate: p)
    }
}
