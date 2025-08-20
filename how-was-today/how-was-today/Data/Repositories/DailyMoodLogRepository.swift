//
//  DailyMoodLogRepository.swift
//  how-was-today
//
//  Created by stocktong on 8/18/25.
//

import Foundation

protocol DailyMoodLogRepository {
    func fetchMood(on date: Date) -> Mood?
    func saveMood(on date: Date, _ mood: Mood) throws
    func deleteMood(on date: Date) throws
}

final class DailyMoodLogRepositoryImpl<Storage: DataStorage>: DailyMoodLogRepository
where Storage.ObjectType == DailyMoodLog {

    private let storage: Storage
    init(storage: Storage) { self.storage = storage }
    
    func fetchMood(on date: Date) -> Mood? {
        let id = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", id)
        let one = try? storage.fetch(predicate: p, sortDescriptors: nil)?.first
        return Mood(rawValue: one?.mood ?? "")
    }
    
    func saveMood(on date: Date, _ mood: Mood) throws {
        let id = date.toString(format: DailyRecord.dateFormat)
        let log = DailyMoodLog()
        log.id = id
        log.date = date
        log.mood = mood.rawValue
        try storage.save(log)
    }
    
    func deleteMood(on date: Date) throws {
        let id = date.toString(format: DailyRecord.dateFormat)
        let p = NSPredicate(format: "id == %@", id)
        try storage.deleteAll(predicate: p)
    }
}
