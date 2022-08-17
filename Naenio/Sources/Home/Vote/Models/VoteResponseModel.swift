//
//  VoteResponseModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/17.
//

struct VoteResponseModel: ModelType {
    var id: Int
    var postId: Int
    var choiceId: Int
    var memberId: Int
    var createdDateTime: String
    var lastModifiedDateTime: String
}
