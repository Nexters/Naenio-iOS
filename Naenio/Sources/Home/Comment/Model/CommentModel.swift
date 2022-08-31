//
//  CommentInformation.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import Foundation

struct CommentModel: ModelType {
    let totalCommentCount: Int
    let comments: [Comment]
    
    struct Comment: ModelType, Identifiable {
        let id: Int
        var author: Author
        let content: String
        let createdDatetime: String
        var likeCount: Int
        var isLiked: Bool
        var repliesCount: Int
        
        struct Author: ModelType {
            let id: Int
            let nickname: String?
            let profileImageIndex: Int?
        }
    }
}
