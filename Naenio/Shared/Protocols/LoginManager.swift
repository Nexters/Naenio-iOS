//
//  LoginManager.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import Foundation

protocol LoginManager {
    func requestLogin() -> LoginResponse?
}
