//
//  HeaderInformation.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/14.
//

import Foundation

enum NaenioAPIHeaderKey {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
    static let accept = "accept"
}

enum NaenioAPIHeaderValue {
    static let json = "application/json"
    static let authoization = "Bearer \(TokenManager.shared.accessToken ?? "")" // FIXME: 이게 여기에 있으면 안될 것 같음
}

