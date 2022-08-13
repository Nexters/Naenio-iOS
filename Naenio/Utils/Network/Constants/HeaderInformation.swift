//
//  HeaderInformation.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/14.
//

import Foundation

class HeaderInformation {
    private static let tokenManager = TokenManager()
    
    enum HeaderKey {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
        static let accept = "accept"
    }
    
    enum HeaderValue {
        static let json = "application/json"
        static let authoization = "Bearer \(tokenManager.accessToken ?? "") "
    }
}
