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
    
    func fetchPlan_returnsLatestOnOrBeforeDate() {
        // Given
        let fake = FakeRealmStorage_SupplementPlan()
            .seed([
                ("2025-08-01", ["A"]),
                ("2025-08-05", ["B"]),
                ("2025-08-10", ["C"])
            ])
        let repo = SupplementPlanRepositoryImpl(storage: fake)

        // When
        let result = repo.fetchPlan(date: idDate("2025-08-09T00:00:00Z"))

        // Then
        XCTAssertEqual(result.names, ["B"])
    }

    func savePlan_upsertsById_thenFetchReflectsNew() {
        // Given
        let fake = FakeRealmStorage_SupplementPlan()
            .seed([("2025-08-12", ["D", "E", "F"])])
        let repo = SupplementPlanRepositoryImpl(storage: fake)
        let date = idDate("2025-08-12T00:00:00Z")

        // When
        XCTAssertNoThrow(try repo.savePlan(Supplement(date: date, supplements: ["G"])))


        // Then
        let result = repo.fetchPlan(date: date)
        XCTAssertEqual(result.names, ["G"])
    }

    func fetchPlan_returnsEmpty_whenNoPastData() {
        // Given
        let fake = FakeRealmStorage_SupplementPlan()
            .seed([("2025-08-10", ["A"])])
        let repo = SupplementPlanRepositoryImpl(storage: fake)

        // When
        let result = repo.fetchPlan(date: idDate("2025-08-09T00:00:00Z"))

        // Then
        XCTAssertTrue(result.names.isEmpty)
    }
}
