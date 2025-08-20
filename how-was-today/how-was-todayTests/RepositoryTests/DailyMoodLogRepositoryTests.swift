//
//  DailyMoodLogRepositoryTests.swift
//  how-was-today
//
//  Created by stocktong on 8/18/25.
//

import Foundation
import XCTest
@testable import how_was_today

final class DailyMoodLogRepositoryTests: XCTestCase {
    
    private func idDate(_ iso: String) -> Date {
        ISO8601DateFormatter().date(from: iso)!
    }
    
    func test_fetchMood_noData() {
        let fake = FakeRealmStorage<DailyMoodLogFactory>()
        let repo = DailyMoodLogRepositoryImpl(storage: fake)
        
        let date = idDate("2025-08-01T00:00:00Z")
        let result1 = repo.fetchMood(on: date)
        XCTAssertNil(result1)
    }
    
    func test_fetchMood_haveDatas() {
        let fake = FakeRealmStorage<DailyMoodLogFactory>().seed([
            .init(id: "2025-08-01", mood: "꿀잼🤩"),
            .init(id: "2025-08-03", mood: "노잼😑"),
            .init(id: "2025-08-05", mood: "일치하는데이터없음")
        ])
        let repo = DailyMoodLogRepositoryImpl(storage: fake)
        
        let result1 = repo.fetchMood(on: idDate("2025-08-01T00:00:00Z"))
        let result2 = repo.fetchMood(on: idDate("2025-08-02T00:00:00Z"))
        let result3 = repo.fetchMood(on: idDate("2025-08-05T00:00:00Z"))
        
        XCTAssertEqual(result1, Mood.fun)
        XCTAssertNil(result2)
        XCTAssertNil(result3)
    }
    
    func test_saveMood_overwritesExisting() throws {
        let date = idDate("2025-08-03T00:00:00Z")
        
        let fake = FakeRealmStorage<DailyMoodLogFactory>()
        let repo = DailyMoodLogRepositoryImpl(storage: fake)
        
        try repo.saveMood(on: date, .fun)
        let result1 = repo.fetchMood(on: date)
        XCTAssertEqual(result1, Mood.fun)
        
        try repo.saveMood(on: date, .angry)
        let result2 = repo.fetchMood(on: date)
        XCTAssertEqual(result2, Mood.angry)
    }
    
    func test_deleteMood() throws {
        let date = idDate("2025-08-03T00:00:00Z")
        
        let fake = FakeRealmStorage<DailyMoodLogFactory>().seed([
            .init(id: "2025-08-01", mood: "꿀잼🤩"),
            .init(id: "2025-08-03", mood: "노잼😑")
        ])
        let repo = DailyMoodLogRepositoryImpl(storage: fake)
        try repo.deleteMood(on: date)
        let result1 = repo.fetchMood(on: date)
        XCTAssertNil(result1)
        
        let result2 = repo.fetchMood(on: idDate("2025-08-01T00:00:00Z"))
        XCTAssertEqual(result2, Mood.fun)
    }
}

private struct DailyMoodLogFactory: RealmObjectFactory {
    
    typealias Model = DailyMoodLog
    
    struct Seed {
        let id: String
        let mood: String
    }
    
    static func make(from seed: Seed) -> DailyMoodLog {
        let p = DailyMoodLog()
        p.id = seed.id
        p.mood = seed.mood
        return p
    }
    
    static func key(of object: DailyMoodLog) -> String {
        object.id
    }
    
    static func key(from seed: Seed) -> String {
        seed.id
    }
}
