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
            
        case .postVote: return "/app/votes"
        case .postComment: return "/app/comments"
        case .postPost, .getTheme: return "/app/posts"
            
        case .getUser: return "app/members/me"
        case .getFeed: return "/app/feed"
        case .getComment(let postId, _): return "/app/posts/\(postId)/comments"
        case .getSinglePost(let info): return "/app/posts/\(info.id)"
        }
    }
}
