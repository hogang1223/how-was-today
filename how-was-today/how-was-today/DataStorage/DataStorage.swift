//
//  DataStorage.swift
//  how-was-today
//
//  Created by stocktong on 8/8/25.
//

import Foundation

protocol DataStorage {
    associatedtype ObjectType

    func save(_ object: ObjectType)
    func fetch(predicate: NSPredicate?) -> [ObjectType]?
    func delete(_ object: ObjectType)
    func deleteAll(predicate: NSPredicate?)
}

extension DataStorage {
    func deleteAll(predicate: NSPredicate?) {}
}
