//
//  TokenManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/02.
//

import Foundation

class TokenManager: ObservableObject {
    static let shared = TokenManager()
    
    // Dependencies
    private let localStorageManager: LocalStorageManager
    let key = LocalStorageKeys.accessToken.rawValue

    // Published vars
    @Published private(set) var accessToken: String?
    
    var isTokenAvailable: Bool {
        return accessToken == nil ? false : true
    }
    
    // Methods
    func saveToken(_ accessToken: String) {
        self.accessToken = accessToken
        localStorageManager.save(accessToken, key: self.key)
    }
    
    func loadToken() -> String? {
        if let loaded = localStorageManager.load(key: self.key),
           let accessToken = loaded as? String {
            return accessToken
        } else {
            return nil
        }
    }
    
    func deleteToken() {
        self.accessToken = nil
        localStorageManager.delete(key: key)
    }
    
    init(_ localStorageManager: LocalStorageManager = LocalStorageManager.shared) {
        self.localStorageManager = localStorageManager
        self.accessToken = loadToken()
    }
}
