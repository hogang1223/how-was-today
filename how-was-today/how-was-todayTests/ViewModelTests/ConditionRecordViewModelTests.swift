//
//  ConditionRecordViewModelTests.swift
//  how-was-today
//
//  Created by hogang on 8/22/25.
//

import XCTest
@testable import how_was_today

private let testDate = ISO8601DateFormatter().date(from: "2025-08-21T00:00:00Z")!

struct ConditionRecordViewModelFactoryForTests {
    let date: Date
    let store = MockConditionStore()
    
    init(date: Date = testDate) { // 고정된 테스트 날짜
        self.date = date
    }
    
    func make() -> ConditionRecordViewModel<MockConditionStore> {
        ConditionRecordViewModel(date: date, store: store)
    }
    
    func stubStore(_ options: [ConditionOption]) {
        store.itemByDate[store.key(from: date)] = options
    }
}

final class ConditionRecordViewModelTests: XCTestCase {
    
    private let factory = ConditionRecordViewModelFactoryForTests()
    
    // 1) disableReset
    func test_disableReset_true_whenOptionsEmpty() {
        // Given
        let vm = factory.make()
        // Then
        XCTAssertTrue(vm.disableReset)
    }
    
    func test_disableReset_false_whenOptionsNotEmpty() {
        // Given
        let vm = factory.make()
        let option = ConditionCatalog.option(for: "good_fresh")!
        
        // When
        vm.toggle(option)
        
        // Then
        XCTAssertFalse(vm.disableReset)
    }
    
    // 2) reset()
    func test_reset_clearsOptions() {
        // Given
        let vm = factory.make()
        let options = [
            ConditionCatalog.option(for: "good_fresh")!,
            ConditionCatalog.option(for: "good_energy")!
        ]
        vm.options = Set(options)
        
        // When
        vm.reset()
        
        // Then
        XCTAssertEqual(vm.options.count, 0)
        XCTAssertTrue(vm.disableReset)
    }
    
    // 3) toggle()
    func test_toggle_insertsAndRemoves() {
        let vm = factory.make()
        let option = ConditionCatalog.option(for: "good_fresh")!
        
        vm.toggle(option)
        XCTAssertTrue(vm.options.contains(option))
        
        vm.toggle(option)
        XCTAssertFalse(vm.options.contains(option))
    }
    
    // 4) refresh() → store.refresh 호출 + fetch 반영
    func test_refresh_callsStoreRefresh_andFetchesItems() {
        // Given
        let vm = factory.make()
        let options = [ConditionCatalog.option(for: "good_fresh")!]
        factory.stubStore(options)
        
        // When
        vm.refresh()
        
        // Then
        XCTAssertEqual(factory.store.refreshedDates.count, 1)
        XCTAssertEqual(factory.store.refreshedDates.first, testDate)
        XCTAssertEqual(vm.options, Set(options))
    }
    
    // 5) fetch() → store의 아이템을 Set으로 반영
    func test_fetch_setsOptionsFromStore() {
        // Given
        let vm = factory.make()
        let options = [
            ConditionCatalog.option(for: "good_fresh")!,
            ConditionCatalog.option(for: "good_energy")!,
            ConditionCatalog.option(for: "good_fresh")!
        ]
        factory.stubStore(options)
        
        // When
        vm.fetch()
        
        // Then
        XCTAssertEqual(vm.options, Set(options))
    }
    
    // 6) save() – 옵션이 비면 delete 호출
    func test_save_whenOptionsEmpty_callsDelete() {
        let vm = factory.make()
        let options = [
            ConditionCatalog.option(for: "good_fresh")!,
            ConditionCatalog.option(for: "good_energy")!
        ]
        factory.stubStore(options)
        // Given
        vm.reset()
        
        // When
        vm.save()
        
        // Then
        XCTAssertTrue(factory.store.deletedDates.contains(testDate))
    }
    
    // 7) save() – 카탈로그 순서대로 저장되는지
    func test_save_persistsSelectedOptions_inCatalogOrder() {
        let vm = factory.make()
        
        // Given: 세 개 선택 (순서 뒤섞음)
        let all = ConditionType.allCases.flatMap { ConditionCatalog.options(for: $0) }
        guard all.count >= 3 else {
            XCTFail("Catalog must contain at least 3 options for this test")
            return
        }
        let a = all[5]
        let b = all[1]
        let c = all[9]
        
        vm.options = [b, c, a]  // 뒤섞인 선택
        
        // When
        vm.save()
        
        // Then
        let saved = factory.store.saved.first
        XCTAssertNotNil(saved, "No saved items found")
        let expected = all.filter { vm.options.contains($0) }  // 카탈로그 순서 기준 필터
        XCTAssertEqual(saved!.1, expected, "Saved order should follow catalog order")
    }
    
    // 8) delete()
    func test_delete_clearsStoreForDate() {
        // Given
        let vm = factory.make()
        let options = [
            ConditionCatalog.option(for: "good_fresh")!,
            ConditionCatalog.option(for: "good_energy")!
        ]
        factory.stubStore(options)
        
        // When
        vm.delete()
        
        // Then
        XCTAssertTrue(factory.store.deletedDates.contains(testDate))
        XCTAssertEqual(factory.store.item(on: testDate) ?? [], [])
    }
}
