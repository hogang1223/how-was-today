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
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            // TODO: Realm 초기화 실패 시 처리 어떻게 할지
            fatalError("❗ Realm 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    func save(_ object: T) {
        create(object)
    }
    
    func fetch(predicate: NSPredicate?) -> [T]? {
        guard let results = fetch(T.self, predicate: predicate) else { return nil }
        return Array(results)
    }
    
    func delete(_ object: ObjectType) {
        delete(object: object)
    }
    
    func deleteAll(predicate: NSPredicate?) {
        deleteAll(T.self, filter: predicate)
    }
}

// MARK: CRUD

extension RealmStorage {
    
    /// Create or Update
    func create(_ object: T, update: Realm.UpdatePolicy = .modified) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.add(object, update: update)
            }
        } catch {
            print("❗️Realm 생성/업데이트 실패: \(error)")
        }
    }
    
    /// Read
    func fetch(_ type: T.Type, predicate: NSPredicate?) -> Results<T>? {
        guard let realm else { return nil }
        let results = realm.objects(type)
        if let filter = predicate {
            return results.filter(filter)
        }
        return results
    }
    
    /// Delete
    func delete(object: T) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("❗️Realm 삭제 실패: \(error)")
        }
    }
    
    /// Delete by filtering
    func deleteAll(_ type: T.Type, filter: NSPredicate? = nil) {
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
        }
    }
}
