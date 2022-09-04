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
        case .postCommentLike: return "/app/comment-likes"
        case .postReport: return "/app/reports"
            
        case .getUser: return "/app/members/me"
        case .getFeed: return "/app/feed"
        case .getRandomPost: return "/app/posts-random"
        case .getComment(let postId, _): return "/app/posts/\(postId)/comments"
        case .getCommentReplies(let postId, _): return "/app/comments/\(postId)/comment-replies"
        case .getSinglePost(let info): return "/app/posts/\(info.id)"
        case .getIsNicknameAvailable(let nickname): return "/app/members/exist?nickname=\(nickname)"
        case .getNotice: return "/app/notices"
            
        case .putNickname: return "/app/members/nickname"
        case .putProfileIndex: return "/app/members/profile-image"
            
        case .deleteAccount: return "/app/members/me"
        case .deleteCommentLike: return "/app/comment-likes"
        case .deletePost(let postId): return "/app/posts/\(postId)"
        case .deleteComment(let commentId): return "/app/comments/\(commentId)"
        }
    }
}
