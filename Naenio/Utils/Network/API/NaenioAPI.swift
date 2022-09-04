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
    case postCommentLike(Int)
    case postReport(ReportRequestModel)
    
    case getUser(String)
    case getFeed(FeedRequestInformation)
    case getComment(postId: Int, model: CommentListRequestModel)
    case getCommentReplies(postId: Int, model: CommentRepliesRequestModel)
    case getTheme(ThemeRequestModel)
    case getRandomPost
    case getSinglePost(SinglePostRequestInformation)
    case getIsNicknameAvailable(String)
    case getMyComment(MyCommentRequest)
    case getNotice
    
    case putNickname(String)
    case putProfileIndex(Int)
    
    case deleteAccount
    case deleteCommentLike(Int)
    case deletePost(Int)
    case deleteComment(Int)
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
            return [NaenioAPIHeaderKey.contentType: NaenioAPIHeaderValue.json]
        default:
            return [
                NaenioAPIHeaderKey.accept: NaenioAPIHeaderValue.json,
                NaenioAPIHeaderKey.contentType: NaenioAPIHeaderValue.json,
                NaenioAPIHeaderKey.authorization: NaenioAPIHeaderValue.authoization
            ]
        }
    }
}
