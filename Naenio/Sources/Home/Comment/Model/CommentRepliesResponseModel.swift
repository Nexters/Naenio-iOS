//
//  CommentRepliesResponseModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/23.
//

import Foundation

struct CommentRepliesResponseModel: ModelType {
    var commentReplies: [CommentRepliesListModel]
    
    struct CommentRepliesListModel: ModelType {
        var id: Int
        var author: Author
        var content: String
        var createdDatetime: String
        var likeCount: Int
        var isLiked: Bool
    }
}
