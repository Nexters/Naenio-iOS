//
//  AuthorizationAPI+Path.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//

import Moya

extension NaenioAPI {
    func getPath() -> String {
        switch self {
        case .login: return "/app/login"
        case .signOut: return "/app/signOut"
        case .withDrawal: return "/app/withDrawal"
            
        case .postPost: return "/app/posts"
        }
    }
}
