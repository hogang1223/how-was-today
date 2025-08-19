//
//  DailyWeightLogRepositoryTests.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation
import XCTest
@testable import how_was_today

final class DailyWeightLogRepositoryTests: XCTestCase {
    
    private func idDate(_ iso: String) -> Date {
        ISO8601DateFormatter().date(from: iso)!
    }
    
    func test_fetchLastestWeight_whenNoLog_returnsNil() {
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
        let repo = DailyWeightLogRepositoryImpl(storage: fake)
        
        let date = idDate("2025-08-01T00:00:00Z")
        let result = repo.fetchLastestWeight(on: date)
        XCTAssertNil(result)
    }
    
    func test_fetchLastestWeight_whenGivenDate_picksMostRecentDate() {
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
            .seed([
                .init(id: "2025-08-03", weight: 55.0),
                .init(id: "2025-08-05", weight: 56.5),
                .init(id: "2025-08-10", weight: 58.3)
            ])
        let repo = DailyWeightLogRepositoryImpl(storage: fake)
        
        let result1 = repo.fetchLastestWeight(on: idDate("2025-08-07T00:00:00Z"))
        let result2 = repo.fetchLastestWeight(on: idDate("2025-08-01T00:00:00Z"))
        let result3 = repo.fetchLastestWeight(on: idDate("2025-08-10T00:00:00Z"))
        
        XCTAssertEqual(result1, Optional(56.5))
        XCTAssertNil(result2)
        XCTAssertEqual(result3, Optional(58.3))
    }
    
    func test_fetchWeightExactDate() {
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
            .seed([
                .init(id: "2025-08-03", weight: 55.0),
                .init(id: "2025-08-05", weight: 56.5),
                .init(id: "2025-08-10", weight: 58.3)
            ])
        let repo = DailyWeightLogRepositoryImpl(storage: fake)
        
        let result1 = repo.fetchWeight(on: idDate("2025-08-07T00:00:00Z"))
        let result2 = repo.fetchWeight(on: idDate("2025-08-01T00:00:00Z"))
        let result3 = repo.fetchWeight(on: idDate("2025-08-10T00:00:00Z"))
        
        XCTAssertNil(result1)
        XCTAssertNil(result2)
        XCTAssertEqual(result3, Optional(58.3))
    }
    
    func test_saveWeight_overwritesSameDate() throws {
        let date = idDate("2025-08-03T00:00:00Z")
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
        let repo = DailyWeightLogRepositoryImpl(storage: fake)
        
        try repo.saveWeight(on: date, 67.4)
        XCTAssertEqual(repo.fetchWeight(on: date), 67.4)
        
        try repo.saveWeight(on: date, 79.3)
        XCTAssertEqual(repo.fetchWeight(on: date), 79.3)
    }
    
    func test_deleteWeight_removesOnlyThatDate_andAffectsQueries() throws {
        // given
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
            .seed([
                .init(id: "2025-08-03", weight: 55.0),
                .init(id: "2025-08-05", weight: 56.5),
                .init(id: "2025-08-10", weight: 58.3)
            ])
        let repo = DailyWeightLogRepositoryImpl(storage: fake)

        let d0503 = idDate("2025-08-03T00:00:00Z")
        let d0505 = idDate("2025-08-05T00:00:00Z")
        let d0810 = idDate("2025-08-10T00:00:00Z")

        // when
        try repo.deleteWeight(on: d0505)

        // then
        XCTAssertNil(repo.fetchWeight(on: d0505))
        XCTAssertEqual(repo.fetchWeight(on: d0503), 55.0)
        XCTAssertEqual(repo.fetchWeight(on: d0810), 58.3)

        // latest on 8/07 should now fallback to 8/03 (since 8/05 was deleted)
        let latest = repo.fetchLastestWeight(on: idDate("2025-08-07T00:00:00Z"))
        XCTAssertEqual(latest, 55.0)
    }

    func test_deleteWeight_idempotent_whenCalledTwice() throws {
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
            .seed([ .init(id: "2025-08-05", weight: 56.5) ])
        let repo = DailyWeightLogRepositoryImpl(storage: fake)

        let date = idDate("2025-08-05T00:00:00Z")

        try repo.deleteWeight(on: date)
        XCTAssertNil(repo.fetchWeight(on: date))

        // second call shouldn't throw
        try repo.deleteWeight(on: date)
        XCTAssertNil(repo.fetchWeight(on: date))
    }

    func test_fetchLatest_ignoresFutureDates() {
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
            .seed([
                .init(id: "2025-08-03", weight: 55.0),
                .init(id: "2025-08-12", weight: 60.0) // future relative to query date
            ])
        let repo = DailyWeightLogRepositoryImpl(storage: fake)

        let result = repo.fetchLastestWeight(on: idDate("2025-08-07T00:00:00Z"))
        XCTAssertEqual(result, 55.0) // must not pick 8/12
    }

    func test_fetchLatest_withUnsortedSeed_stillPicksCorrect() {
        // deliberately unsorted
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
            .seed([
                .init(id: "2025-08-10", weight: 58.3),
                .init(id: "2025-08-03", weight: 55.0),
                .init(id: "2025-08-05", weight: 56.5)
            ])
        let repo = DailyWeightLogRepositoryImpl(storage: fake)

        let r1 = repo.fetchLastestWeight(on: idDate("2025-08-06T00:00:00Z"))
        XCTAssertEqual(r1, 56.5)

        let r2 = repo.fetchLastestWeight(on: idDate("2025-08-10T00:00:00Z"))
        XCTAssertEqual(r2, 58.3)
    }

    func test_saveWeight_thenLatestAcrossDates() throws {
        let fake = FakeRealmStorage<DailyWeightLogFactory>()
        let repo = DailyWeightLogRepositoryImpl(storage: fake)

        try repo.saveWeight(on: idDate("2025-08-01T00:00:00Z"), 54.2)
        try repo.saveWeight(on: idDate("2025-08-05T00:00:00Z"), 56.1)
        try repo.saveWeight(on: idDate("2025-08-09T00:00:00Z"), 57.0)

        XCTAssertEqual(repo.fetchLastestWeight(on: idDate("2025-08-04T00:00:00Z")), 54.2)
        XCTAssertEqual(repo.fetchLastestWeight(on: idDate("2025-08-05T00:00:00Z")), 56.1) // boundary ==
        XCTAssertEqual(repo.fetchLastestWeight(on: idDate("2025-08-08T00:00:00Z")), 56.1)
        XCTAssertEqual(repo.fetchLastestWeight(on: idDate("2025-08-10T00:00:00Z")), 57.0)
    }
}

// MARK: - DailyWeightLogFactory

private enum DailyWeightLogFactory: RealmObjectFactory {
    typealias Model = DailyWeightLog
    
    struct Seed {
        let id: String
        let weight: Double
    }
    
    static func make(from seed: Seed) -> DailyWeightLog {
        let p = DailyWeightLog()
        p.id = seed.id
        p.weight = seed.weight
        return p
    }
    
    static func key(of object: DailyWeightLog) -> String {
        object.id
    }
    
    static func key(from seed: Seed) -> String {
        seed.id
    }
}
