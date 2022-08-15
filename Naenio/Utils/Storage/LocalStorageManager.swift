//
//  LocalStorageManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/02.
//

import Foundation

/// Thread safe
///
/// 왜냐면 `UserDefault` 쓸건데 이게 thread safe
class LocalStorageManager {
    static let shared = LocalStorageManager()
    
    let storage: UserDefaults
    
    func save(_ value: String, key: String) {
        storage.set(value, forKey: key)
    }
    
    func load(key: String) -> Any? {
        return storage.object(forKey: key)
    }
    
    func delete(key: String) {
        storage.removeObject(forKey: key)
    }
    
    init(_ storage: UserDefaults = UserDefaults.standard) {
        self.storage = storage
    }
}
