//
//  SupplementInputViewModelTests.swift
//  how-was-today
//
//  Created by hogang on 8/13/25.
//

import XCTest
@testable import how_was_today

struct SupplementInputViewModelFactoryForTests {
    
    var repo = MockSupplementPlanRepository()

    func make() -> SupplementInputViewModel {
        SupplementInputViewModel(supplementRepo: repo)
    }
    
    func stubRepo(_ items: [String], date: Date? = nil) {
        let d = date ?? Date()
        repo.setStub(
            Supplement(date: d, supplements: items),
            for: d
        )
    }
}

final class SupplementInputViewModelTests: XCTestCase {
    
    private let factory = SupplementInputViewModelFactoryForTests()
    
    // 1) disableReset
    func test_disableReset_true_whenNoInputsAndNoAlarm() {
        let vm = factory.make()
        // Given
        vm.supplements = ["", "", ""]
        vm.alarmEnabled = false
        vm.alarmTime = nil

        // Then
        XCTAssertTrue(vm.disableReset)
    }

    func test_disableReset_false_whenHasAnyInputOrAlarm() {
        let vm = factory.make()
        
        // Given
        vm.supplements = ["오메가3", "", ""]
        // Then
        XCTAssertFalse(vm.disableReset)

        // Or alarm만 켜도 false
        vm.supplements = ["", "", ""]
        vm.alarmEnabled = true
        vm.alarmTime = Date()
        XCTAssertFalse(vm.disableReset)
    }

    // 2) reset()
    func test_reset_clearsInputs_andAlarm_andDisablesReset() {
        let vm = factory.make()
        
        // Given
        vm.supplements = ["오메가3", "마그네슘", ""]
        vm.alarmEnabled = true
        vm.alarmTime = Date()

        // When
        vm.reset()

        // Then
        XCTAssertEqual(vm.supplements, ["", "", ""])
        XCTAssertFalse(vm.alarmEnabled)
        XCTAssertNil(vm.alarmTime)
        XCTAssertTrue(vm.disableReset)
    }

    // 3) save()
    func test_save_trimsAndFiltersEmpty_andCallsRepository() {
        let vm = factory.make()
        let mock = factory.repo
        
        // Given
        vm.supplements = ["  비타민D ", "   ", "마그네슘", ""]
        // When
        vm.save()
        // Then
        XCTAssertEqual(mock.saveCalledWith.count, 1)
        XCTAssertEqual(mock.saveCalledWith.first?.names, ["비타민D", "마그네슘"])
    }

    // 4) loadSupplements()
    // init에서 자동 로드되는 경우: 스텁 먼저 넣고 vm 다시 생성해서 검증
    func test_init_loadsSupplements_padsToDefaultCount() {
        factory.stubRepo(["비타민C"])
        let vm = factory.make()
        
        XCTAssertEqual(vm.supplements.count, 3)   // 프로젝트 기본 칸 수에 맞춰 조정
        XCTAssertEqual(vm.supplements[0], "비타민C")
    }

    // 5) addNewSupplements()
    func test_addNewSupplements_appendsEmptySlot_andAffectsDisableReset() {
        let vm = factory.make()
        vm.supplements = ["오메가3"]
        let oldCount = vm.supplements.count

        vm.addNewSupplements()

        XCTAssertEqual(vm.supplements.count, oldCount + 1)
        XCTAssertEqual(vm.supplements.last, "")
        XCTAssertFalse(vm.disableReset) // 값이 있으니 reset 가능
    }
}
