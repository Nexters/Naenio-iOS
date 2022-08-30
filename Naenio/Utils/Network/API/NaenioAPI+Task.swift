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
        case .signOut, .withDrawal, .deleteAccount, .getRandomPost:
            return .requestPlain
            
        case .login(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
            
        case .postPost(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
        case .postVote(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
        case .postComment(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
        case .postReport(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
            
        case .getUser(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.default)
        case .getFeed(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.default)
        case .getSinglePost(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.default)
        case .getTheme(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.default)
        case .getComment( _, let model):
            return .requestParameters(parameters: model.toDictionary(), encoding: URLEncoding.default)
        case .getCommentReplies(_, let model):
            return .requestParameters(parameters: model.toDictionary(), encoding: URLEncoding.default)
        case .getIsNicknameAvailable(let request):
            return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.default)
            
        case .putNickname(let request):
            return .requestParameters(parameters: ["nickname": request], encoding: JSONEncoding.default)
        case .putProfileIndex(let request):
            return .requestParameters(parameters: ["profileImageIndex": request], encoding: JSONEncoding.default)
        }
    }
}
