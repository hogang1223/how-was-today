//
//  MockDailyWeightLogRepository.swift
//  how-was-today
//
//  Created by stocktong on 8/19/25.
//

import Foundation
@testable import how_was_today

final class FakeDailyWeightLogRepository: DailyWeightLogRepository {
    var store: [String: Double] = [:] // key: "yyyy-MM-dd"

    // 에러 주입 플래그
    var nextSaveError: Error?
    var nextDeleteError: Error?

    func fetchLastestWeight(on date: Date) -> Double? {
        let key = date.toString(format: DailyRecord.dateFormat)
        return store
            .filter { $0.key <= key }
            .sorted { $0.key > $1.key }
            .first?.value
    }

    func fetchWeight(on date: Date) -> Double? {
        store[date.toString(format: DailyRecord.dateFormat)]
    }

    func saveWeight(on date: Date, _ weight: Double) throws {
        if let e = nextSaveError { nextSaveError = nil; throw e }
        store[date.toString(format: DailyRecord.dateFormat)] = weight
    }

    func deleteWeight(on date: Date) throws {
        if let e = nextDeleteError { nextDeleteError = nil; throw e }
        store.removeValue(forKey: date.toString(format: DailyRecord.dateFormat))
    }
}
