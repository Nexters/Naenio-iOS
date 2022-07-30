//
//  LoginResponse.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import Foundation

struct LoginRequestInformation: ModelType {
    let authToken: String
    let authServiceType: String
}
