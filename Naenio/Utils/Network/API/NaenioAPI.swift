//
//  AuthorizationAPI.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/14.
//
/*
 API endpoint 케이스 정의
 */

import Moya

enum NaenioAPI {
    case login(LoginRequestInformation)
    case signOut(token: String)
    case withDrawal(token: String)
    
    case postPost(PostRequestInformation)
    case postVote(VoteRequestModel)
    case postComment(CommentPostRequestModel)
    
    case getUser(String)
    case getFeed(FeedRequestInformation)
    case getComment(postId: Int, model: CommentListRequestModel)
    case getCommentReplies(postId: Int, model: CommentRepliesRequestModel)
    case getTheme(ThemeRequestModel)
    case getSinglePost(SinglePostRequestInformation)
    case getIsNicknameAvailable(String)
    
    case putNickname(String)
    case putProfileIndex(Int)
}

extension NaenioAPI: TargetType {
    var baseURL: URL { return URL(string: KeyValue.baseURL)! }

    var path: String { self.getPath() }
    
    var method: Moya.Method { self.getMehod() }
  
    var sampleData: Data { Data() }
    
    var task: Task { self.getTask() }

    var headers: [String: String]? {
        switch self {
        case .login:
            return [HeaderInformation.HeaderKey.contentType: HeaderInformation.HeaderValue.json]
        default:
            return [
                HeaderInformation.HeaderKey.accept: HeaderInformation.HeaderValue.json,
                HeaderInformation.HeaderKey.contentType: HeaderInformation.HeaderValue.json,
                HeaderInformation.HeaderKey.authorization: HeaderInformation.HeaderValue.authoization
            ]
        }
    }
}
