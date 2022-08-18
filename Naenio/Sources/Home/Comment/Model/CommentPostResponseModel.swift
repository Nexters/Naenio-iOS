//
//  CommentResponseModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/18.
//
import Foundation

struct CommentPostResponseModel: ModelType {
    var id: Int
    var memberId: Int
    var parentId: Int
    var parentType: Int
    var content: String
    var createdDateTime: String
    var lastModifiedDateTime: String
}
