//
//  FakeRealmStorage_DailySupplementLog.swift
//  how-was-today
//
//  Created by hogang on 8/15/25.
//

import Foundation
@testable import how_was_today

final class FakeRealmStorage_DailySupplementLog {

    // In-memory 저장소 (id를 key로 관리)
    private var store: [String: DailySupplementLog] = [:]
    
    @discardableResult
    func seed(_ items: [(String, Bool)]) -> Self {
        for (id, isTaken) in items {
            let p = DailySupplementLogFactory.make(id: id, isTaken: isTaken)
            store[id] = p
        }
        return self
    }
}

extension FakeRealmStorage_DailySupplementLog: DataStorage {
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [DailySupplementLog]? {
        var items = Array(store.values)
        if let predicate = predicate {
            items = items.filter { predicate.evaluate(with: $0) }
        }
        return items
    }

    /// 동일 id는 upsert
    func save(_ object: DailySupplementLog) throws {
        store[object.id] = object
    }
    
    func delete(_ object: DailySupplementLog) throws {
        store.removeValue(forKey: object.id)
    }
}
