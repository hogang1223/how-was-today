//
//  MockSupplementPlanRepository.swift
//  how-was-today
//
//  Created by hogang on 8/13/25.
//

import Foundation
@testable import how_was_today

final class MockSupplementPlanRepository: SupplementPlanRepository {
    // Stub
    var stubFetchById: [String: Supplement] = [:]
    var defaultFetch: Supplement = Supplement(date: nil, names: [])
    var saveError: Error?

    // Capture
    private(set) var fetchCalledWith: [Date] = []
    private(set) var saveCalledWith: [Supplement] = []

    // Date → "yyyy-MM-dd"
    private let df: DateFormatter = {
        let f = DateFormatter()
        f.locale = .init(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = Supplement.dateFormat  // 실제 포맷 따라가자
        return f
    }()

    func fetchPlan(date: Date) -> Supplement {
        fetchCalledWith.append(date)
        let id = df.string(from: date)
        return stubFetchById[id] ?? defaultFetch
    }

    func savePlan(_ plan: Supplement) throws {
        if let e = saveError { throw e }
        saveCalledWith.append(plan)
    }
}

extension MockSupplementPlanRepository {
    
    func setStub(_ result: Supplement, for date: Date) {
        stubFetchById[df.string(from: date)] = result
    }
}
