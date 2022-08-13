//
//  NaenioAPI+Method.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/13.
//
import Moya
extension NaenioAPI {
    func getMehod() -> Moya.Method {
        switch self {
        case .signOut, .withDrawal, .login, .postPost: return .post
        }
    }
}
