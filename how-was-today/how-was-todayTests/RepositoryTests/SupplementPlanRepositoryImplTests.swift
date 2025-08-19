//
//  SupplementPlanRepositoryImplTests.swift
//  how-was-today
//
//  Created by hogang on 8/12/25.
//

import Foundation
import XCTest
@testable import how_was_today

final class  SupplementPlanRepositoryImplTests: XCTestCase {
    
    private func idDate(_ iso: String) -> Date {
        ISO8601DateFormatter().date(from: iso)!
    }
    
    func test_fetchPlan_returnsLatestOnOrBeforeDate() {
        // Given
        let fake = FakeRealmStorage<SupplementPlanFactory>()
            .seed([
                .init(id: "2025-08-01", names: ["A"]),
                .init(id: "2025-08-05", names: ["B"]),
                .init(id: "2025-08-10", names: ["C"])
            ])
        let repo = SupplementPlanRepositoryImpl(storage: fake)

        // When
        let result = repo.fetchPlan(date: idDate("2025-08-09T00:00:00Z"))

        // Then
        XCTAssertEqual(result.names, ["B"])
    }

    func test_savePlan_upsertsById_thenFetchReflectsNew() {
        // Given
        let fake = FakeRealmStorage<SupplementPlanFactory>()
            .seed([
                .init(id: "2025-08-12", names: ["D", "E", "F"])
            ])
        let repo = SupplementPlanRepositoryImpl(storage: fake)
        let date = idDate("2025-08-12T00:00:00Z")

        // When
        XCTAssertNoThrow(
            try repo.savePlan(
                Supplement(date: date, names: ["G"])
            )
        )
        
        // Then
        let result = repo.fetchPlan(date: date)
        XCTAssertEqual(result.names, ["G"])
    }

    func test_fetchPlan_returnsEmpty_whenNoPastData() {
        // Given
        let fake = FakeRealmStorage<SupplementPlanFactory>()
            .seed([
                .init(id: "2025-08-10", names: ["A"])
            ])
        let repo = SupplementPlanRepositoryImpl(storage: fake)

        // When
        let result = repo.fetchPlan(date: idDate("2025-08-09T00:00:00Z"))

        // Then
        XCTAssertTrue(result.names.isEmpty)
    }
}

// MARK: - SupplementPlanFactory

private enum SupplementPlanFactory: RealmObjectFactory {
    typealias Model = SupplementPlan
    
    struct Seed {
        let id: String
        let names: [String]
    }
    
    static func make(from seed: Seed) -> SupplementPlan {
        let p = SupplementPlan()
        p.id = seed.id
        p.append(names: seed.names)
        return p
    }
    
    static func key(of object: SupplementPlan) -> String {
        object.id
    }
    
    static func key(from seed: Seed) -> String {
        seed.id
    }
}
