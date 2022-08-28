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
    
    struct Comment: ModelType {
        let id: Int
        let author: Author
        let content: String
        let createdDatetime: String
        let likeCount: Int
        let isLiked: Bool
        let repliesCount: Int
        
        struct Author: ModelType {
            let id: Int
            let nickname: String?
            let profileImageIndex: Int?
        }
    }
}
