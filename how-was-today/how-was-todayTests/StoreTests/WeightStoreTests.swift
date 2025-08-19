//
//  WeightStoreTests.swift
//  how-was-today
//
//  Created by stocktong on 8/19/25.
//

import Foundation
import XCTest
@testable import how_was_today

final class WeightStoreTests: XCTestCase {
    
    private func idDate(_ iso: String) -> Date {
        ISO8601DateFormatter().date(from: iso)!
    }
    
    func test_refresh_setsCache_whenRepoHasValue() {
        // given
        let repo = FakeDailyWeightLogRepository()
        let date = idDate("2025-08-05T00:00:00Z")
        let key = date.toString(format: DailyRecord.dateFormat)
        repo.store[key] = 56.7
        
        let sut = WeightStore(repo: repo)
        
        // when
        sut.refresh(date: date)
        
        // then
        XCTAssertEqual(sut.weight(on: date), 56.7)
    }
    
    func test_refresh_doesNothing_whenRepoReturnsNil() {
        let repo = FakeDailyWeightLogRepository()
        let date = idDate("2025-08-05T00:00:00Z")
        let sut = WeightStore(repo: repo)
        
        sut.refresh(date: date)
        
        XCTAssertNil(sut.weight(on: date))
    }
    
    func test_save_updatesRepoAndCache_onSuccess() {
        let repo = FakeDailyWeightLogRepository()
        let date = idDate("2025-08-03T00:00:00Z")
        let sut = WeightStore(repo: repo)
        
        sut.save(70.3, on: date)
        
        XCTAssertEqual(repo.fetchWeight(on: date), 70.3)
        XCTAssertEqual(sut.weight(on: date), 70.3)
    }
    
    struct DummyError: Error {}
    
    func test_save_doesNotUpdateCache_whenRepoThrows() {
        let repo = FakeDailyWeightLogRepository()
        let date = idDate("2025-08-03T00:00:00Z")
        repo.nextSaveError = DummyError()
        let store = WeightStore(repo: repo)
        
        store.save(71.9, on: date)
        
        XCTAssertNil(repo.fetchWeight(on: date))   // save 실패
        XCTAssertNil(store.weight(on: date))         // 캐시도 업데이트 X
    }
    
    func test_delete_removesFromRepoAndCache_onSuccess() {
        let repo = FakeDailyWeightLogRepository()
        let date = idDate("2025-08-10T00:00:00Z")
        let key = date.toString(format: DailyRecord.dateFormat)
        repo.store[key] = 60.0
        
        let store = WeightStore(repo: repo)
        store.refresh(date: date) // 캐시 세팅
        
        store.delete(on: date)
        
        XCTAssertNil(repo.fetchWeight(on: date))
        XCTAssertNil(store.weight(on: date))
    }
    
    func test_delete_keepsCache_whenRepoThrows() {
        let repo = FakeDailyWeightLogRepository()
        let date = idDate("2025-08-10T00:00:00Z")
        let key = date.toString(format: DailyRecord.dateFormat)
        repo.store[key] = 60.0
        
        let store = WeightStore(repo: repo)
        store.refresh(date: date) // 캐시 세팅
        repo.nextDeleteError = DummyError()
        
        store.delete(on: date)
        
        // repo는 삭제 실패 → 값 남아있을 수 있음(정책 상관없음)
        // 중요한 건 캐시가 함부로 지워지지 않는 것
        XCTAssertEqual(store.weight(on: date), 60.0)
    }
    
    func test_lastestWeight_delegatesToRepo() {
        let repo = FakeDailyWeightLogRepository()
        // 8/01=50.0, 8/05=51.2
        repo.store["2025-08-01"] = 50.0
        repo.store["2025-08-05"] = 51.2
        
        let store = WeightStore(repo: repo)
        
        XCTAssertEqual(store.lastestWeight(date: idDate("2025-08-04T00:00:00Z")), 50.0)
        XCTAssertEqual(store.lastestWeight(date: idDate("2025-08-05T00:00:00Z")), 51.2)
        XCTAssertNil(store.lastestWeight(date: idDate("2025-07-30T00:00:00Z")))
    }
}
