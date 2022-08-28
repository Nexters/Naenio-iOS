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
        case .signOut, .withDrawal, .login, .postPost, .postVote, .postComment: return .post
        case .getUser, .getFeed, .getTheme, .getComment, .getCommentReplies, .getSinglePost, .getIsNicknameAvailable: return .get
        case .putNickname, .putProfileIndex: return .put
        case .deleteAccount: return .delete
        }
    }
}
