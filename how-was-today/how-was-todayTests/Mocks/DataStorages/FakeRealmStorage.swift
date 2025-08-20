//
//  FakeRealmStorage.swift
//  how-was-today
//
//  Created by hogang on 8/17/25.
//

import Foundation
@testable import how_was_today

protocol RealmObjectFactory {
    associatedtype Model          // 만들어질 Realm Object
    associatedtype Seed               // 생성에 필요한 입력값(씨앗)

    static func make(from seed: Seed) -> Model
    static func key(of object: Model) -> String
    static func key(from seed: Seed) -> String
}

final class FakeRealmStorage<F: RealmObjectFactory> {
    
    private var store: [String: F.Model] = [:]
    
    @discardableResult
    func seed(_ seeds: [F.Seed]) -> Self {
        for s in seeds {
            let obj = F.make(from: s)
            store[F.key(of: obj)] = obj
        }
        return self
    }
}

extension FakeRealmStorage: DataStorage {
    typealias Model = F.Model
    
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [Model]? {
        var items = Array(store.values)
        if let predicate = predicate {
            items = items.filter { predicate.evaluate(with: $0) }
        }
        if let sort = sortDescriptors, !sort.isEmpty {
            items = (items as NSArray).sortedArray(using: sort) as? [Model] ?? items
        }
        return items
    }

    func save(_ object: Model) throws {
        store[F.key(of: object)] = object
    }
    
    func delete(_ object: Model) throws {
        store.removeValue(forKey: F.key(of: object))
    }
    
    func deleteAll(predicate: NSPredicate?) throws {
        let all = Array(store.values)
        let targets: [Model]

        if let predicate = predicate {
            targets = all.filter { predicate.evaluate(with: $0) }
        } else {
            targets = all
        }

        for target in targets {
            store.removeValue(forKey: F.key(of: target))
        }
    }
}
