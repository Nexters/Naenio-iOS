//
//  AppleLoginManager.swift
//  Naenio
//
//  Created by enebin on 2022/07/10.
//

import Foundation

class AppleLoginManager: LoginManager {
    func requestLogin() -> LoginResponse? {
        let mockResponse = LoginResponse(accessToken: "")
        
        return mockResponse
    }
}
