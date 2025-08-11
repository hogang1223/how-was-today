//
//  DataStorage.swift
//  how-was-today
//
//  Created by stocktong on 8/8/25.
//

import Foundation

protocol DataStorage {
    associatedtype ObjectType

    func save(_ object: ObjectType) throws
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [ObjectType]?
    func delete(_ object: ObjectType) throws
    func deleteAll(predicate: NSPredicate?) throws
}

extension DataStorage {
    func deleteAll(predicate: NSPredicate?) throws {}
}

protocol KeyValueDataStorage {
    func setValue<T: Codable>(_ value: T, forKey key: String) throws
    func getValue<T: Codable>(forKey key: String, as type: T.Type) -> T?
    func removeValue(forKey key: String) throws
    func hasValue(forKey key: String) -> Bool
}
