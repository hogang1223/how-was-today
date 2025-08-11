//
//  UserDefaultsStorage.swift
//  how-was-today
//
//  Created by stocktong on 8/11/25.
//

import Foundation

final class UserDefaultsStorage: KeyValueDataStorage {
    
    static let shared = UserDefaultsStorage()
    
    private let userDefaults: UserDefaults
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func setValue<T: Codable>(_ value: T, forKey key: String) throws {
        if let data = try? JSONEncoder().encode(value) {
            userDefaults.set(data, forKey: key)
        } else {
            // 기본 타입들은 직접 저장
            userDefaults.set(value, forKey: key)
        }
    }
    
    func getValue<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        // 기본 타입들 먼저 처리
        switch type {
        case is String.Type:
            return userDefaults.string(forKey: key) as? T
        case is Bool.Type:
            return userDefaults.bool(forKey: key) as? T
        case is Int.Type:
            return userDefaults.integer(forKey: key) as? T
        case is Double.Type:
            return userDefaults.double(forKey: key) as? T
        default:
            // 복잡한 객체는 JSON으로 디코딩
            guard let data = userDefaults.data(forKey: key),
                  let value = try? JSONDecoder().decode(type, from: data) else {
                return nil
            }
            return value
        }
    }
    
    func removeValue(forKey key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
    
    func hasValue(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}

extension UserDefaultsStorage {
    enum Keys {
        static let supplementAlarmMinutes = "supplementAlarmMinutes"
    }
}
