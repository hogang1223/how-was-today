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
    
    func fetchWeights(from start: Date, to end: Date) -> [String: Double]
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
    
    func fetchWeights(from start: Date, to end: Date) -> [String: Double] {
        let startKey = start.toString(format: DailyRecord.dateFormat)
        let endKey   = end.toString(format: DailyRecord.dateFormat)

        let p = NSPredicate(format: "id >= %@ AND id < %@", startKey, endKey)
        // 정렬은 선택사항(디버깅/확인용)
        let sort = [NSSortDescriptor(key: "id", ascending: true)]

        guard let items = try? storage.fetch(predicate: p, sortDescriptors: sort) else { return [:] }
        return Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0.weight) })
    }
}
