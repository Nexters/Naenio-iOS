//
//  CommentListRequestModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/19.
//

import Foundation

struct CommentListRequestModel: ModelType {
    var size: Int
    var lastCommentId: Int?
}
