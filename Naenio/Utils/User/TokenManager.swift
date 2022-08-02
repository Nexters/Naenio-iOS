//
//  TokenManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/02.
//

import Foundation

class TokenManager {
    let accessToken: String
//    let refreshToken: String
    
    init(_ userInformation: UserInformation) {
        self.accessToken = userInformation.token 
    }
}
