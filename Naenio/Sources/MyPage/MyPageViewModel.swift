//
//  MyPageViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    // Dependecies
    private let tokenManager: TokenManager
    
    func signOut() {
        tokenManager.deleteToken()
    }
    
    init(_ tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
    }
}
