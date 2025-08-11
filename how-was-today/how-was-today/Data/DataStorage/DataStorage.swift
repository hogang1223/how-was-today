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
