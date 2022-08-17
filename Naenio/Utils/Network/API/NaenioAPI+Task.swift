//
//  AuthorizationAPI+Task.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//

import Moya

extension NaenioAPI {
    func getTask() -> Task {
        switch self {
        case .signOut, .withDrawal:
            return .requestPlain
            
        case .login(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
        case .postPost(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
        case .getFeed(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.default)
        case .postVote(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
        case .getTheme(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
        }
    }
}
