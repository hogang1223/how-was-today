//
//  MockDailySupplementLogRepository.swift
//  how-was-todayTests
//
//  Created by hogang on 8/15/25.
//

import Foundation
@testable import how_was_today

final class MockDailySupplementLogRepository: DailySupplementLogRepository {
    
    // Stub
    var stubIsTakenById: [String: Bool] = [:]
    var setError: Error?
    
    // Capture
    private(set) var fetchCalledWith: [Date] = []
    private(set) var setCalledWith: [(date: Date, value: Bool)] = []
    
    // Date → "yyyy-MM-dd"
    private let df: DateFormatter = {
        let f = DateFormatter()
        f.locale = .init(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = Supplement.dateFormat
        return f
    }()
    
    func fetchIsTaken(on date: Date) -> Bool {
        let id = df.string(from: date)
        return stubIsTakenById[id] ?? false
    }
    
    func setIsTaken(on date: Date, _ value: Bool) throws {
        if let e = setError { throw e }
        let id = df.string(from: date)
        stubIsTakenById[id] = value
    }
}
extension MockDailySupplementLogRepository {
    func setStub(_ value: Bool, for date: Date) {
        stubIsTakenById[df.string(from: date)] = value
    }
}
