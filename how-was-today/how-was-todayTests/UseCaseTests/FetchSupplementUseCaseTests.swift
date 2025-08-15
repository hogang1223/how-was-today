//
//  FetchSupplementUseCaseTests.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import XCTest
@testable import how_was_today

final class FetchSupplementUseCaseTests: XCTestCase {

    private func idDate(_ iso: String) -> Date {
        ISO8601DateFormatter().date(from: iso)!
    }
    
    /// 로그가 없으면 isTaken은 기본 false 여야 한다.
    func test_execute_whenNoLog_setsIsTakenFalse() {
        // given
        let planRepo = MockSupplementPlanRepository()
        let logRepo  = MockDailySupplementLogRepository()
        let sut = FetchSupplementUseCaseImpl(planRepo: planRepo, logRepo: logRepo)

        let date = idDate("2025-08-01T00:00:00Z")
        planRepo.setStub(
            Supplement(date: date, names: ["비타민C", "오메가3"]),
            for: date)
        // logRepo는 stub 세팅 안 함 → 기본 false

        // when
        let result = sut.execute(date: date)

        // then
        XCTAssertEqual(result.date, date)
        XCTAssertEqual(result.names, ["비타민C", "오메가3"])
        XCTAssertFalse(result.isTaken)
    }

    /// 로그가 true면 isTaken이 true로 반영되어야 한다.
    func test_execute_whenLogTrue_setsIsTakenTrue() {
        // given
        let planRepo = MockSupplementPlanRepository()
        let logRepo  = MockDailySupplementLogRepository()
        let sut = FetchSupplementUseCaseImpl(planRepo: planRepo, logRepo: logRepo)

        let date = idDate("2025-08-01T00:00:00Z")
        planRepo.setStub(
            Supplement(date: date, names: ["멀티비타민"]),
            for: date)
        logRepo.setStub(true, for: date)

        // when
        let result = sut.execute(date: date)

        // then
        XCTAssertEqual(result.names, ["멀티비타민"])
        XCTAssertTrue(result.isTaken)
    }

    /// 플랜이 비어 있어도 크래시 없이 동작해야 한다.
    func test_execute_withEmptyPlan_returnsEmptyNames_andRespectsLog() {
        // given
        let planRepo = MockSupplementPlanRepository()
        let logRepo  = MockDailySupplementLogRepository()
        let sut = FetchSupplementUseCaseImpl(planRepo: planRepo, logRepo: logRepo)
        
        let date = idDate("2025-08-01T00:00:00Z")
        logRepo.setStub(true, for: date)

        // when
        let result = sut.execute(date: date)

        // then
        XCTAssertEqual(result.date, date)
        XCTAssertEqual(result.names, [])
        XCTAssertTrue(result.isTaken)
    }
}
