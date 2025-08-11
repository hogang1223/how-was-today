//
//  RealmStorage.swift
//  how-was-today
//
//  Created by stocktong on 8/8/25.
//

import Foundation
import RealmSwift

final class RealmStorage<T: Object>: DataStorage {
    
    typealias ObjectType = T
    private(set) var realm: Realm?
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            // TODO: Realm 초기화 실패 시 처리 어떻게 할지
            fatalError("❗ Realm 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    func save(_ object: T) throws {
        try upsert(object)
    }
    
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T]? {
        guard let results = fetch(T.self, predicate: predicate, sortDescriptors: sortDescriptors) else { return nil }
        return Array(results)
    }
    
    func delete(_ object: ObjectType) throws {
        try delete(object: object)
    }
    
    func deleteAll(predicate: NSPredicate?) throws {
        try deleteAll(T.self, filter: predicate)
    }
}

// MARK: CRUD

extension RealmStorage {
    
    /// Create or Update
    private func upsert(_ object: T, update: Realm.UpdatePolicy = .modified) throws {
        guard let realm else { return }
        do {
            try realm.write {
                realm.add(object, update: update)
            }
        } catch {
            print("❗️Realm 생성/업데이트 실패: \(error)")
            throw error
        }
    }
    
    /// Read
    private func fetch(_ type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Results<T>? {
        guard let realm else { return nil }
        var results = realm.objects(type)
        
        if let filter = predicate {
            results = results.filter(filter)
        }
        
        if let sort = sortDescriptors, !sort.isEmpty {
            let realmSort: [RealmSwift.SortDescriptor] = sort.compactMap { desc in
                guard let key = desc.key else { return nil }
                return SortDescriptor(keyPath: key, ascending: desc.ascending)
            }
            if !realmSort.isEmpty {
                results = results.sorted(by: realmSort)
            }
        }
        return results
    }
    
    /// Delete
    private func delete(object: T) throws {
        guard let realm else { return }
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("❗️Realm 삭제 실패: \(error)")
            throw error
        }
    }
    
    /// Delete by filtering
    func deleteAll(_ type: T.Type, filter: NSPredicate? = nil) throws {
        guard let realm else { return }
        do {
            let objects: Results<T>
            if let filter {
                objects = realm.objects(type).filter(filter)
            } else {
                objects = realm.objects(type)
            }
            
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print("❗️Realm 일괄 삭제 실패: \(error)")
            throw error
        }
    }
}
