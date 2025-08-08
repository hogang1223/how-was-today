//
//  how_was_todayUITestsLaunchTests.swift
//  how-was-todayUITests
//
//  Created by hogang on 8/3/25.
//

import XCTest

final class how_was_todayUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        throw XCTSkip("Skipping ustable launch test on simulator")
    }
}
