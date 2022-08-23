//
//  CommentRepliesRequestModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/23.
//

import Foundation

struct CommentRepliesRequestModel: ModelType {
    var size: Int
    var lastCommentId: Int?
}
