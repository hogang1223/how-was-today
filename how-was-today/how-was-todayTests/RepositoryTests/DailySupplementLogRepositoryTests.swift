//
//  DailySupplementLogRepositoryTests.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import Foundation
import XCTest
@testable import how_was_today

final class DailySupplementLogRepositoryTests: XCTestCase {
    
    private func idDate(_ iso: String) -> Date {
        ISO8601DateFormatter().date(from: iso)!
    }
    
    func test_fetchIsTaken_whenNoLog_returnsFalse() {
        let fake = FakeRealmStorage_DailySupplementLog()
        let repo = DailySupplementLogRepositoryImpl(storage: fake)
        
        let result = repo.fetchIsTaken(on: idDate("2025-08-01T00:00:00Z"))
        
        XCTAssertFalse(result)
    }

    func test_fetchIsTaken_returnsTrue() {
        let fake = FakeRealmStorage_DailySupplementLog()
        fake.seed([("2025-08-01", true)])
        let repo = DailySupplementLogRepositoryImpl(storage: fake)
        
        let result = repo.fetchIsTaken(on: idDate("2025-08-01T00:00:00Z"))
        
        XCTAssertTrue(result)
    }
    
    func test_setIsTaken_overwritesExisting() throws {
        let date = idDate("2025-08-03T00:00:00Z")
        
        let fake = FakeRealmStorage_DailySupplementLog()
        fake.seed([("2025-08-03", true)])
        let repo = DailySupplementLogRepositoryImpl(storage: fake)
        
        try repo.setIsTaken(on: date, false)
        XCTAssertFalse(repo.fetchIsTaken(on: date))
        
        try repo.setIsTaken(on: date, true)
        XCTAssertTrue(repo.fetchIsTaken(on: date))
    }
}
