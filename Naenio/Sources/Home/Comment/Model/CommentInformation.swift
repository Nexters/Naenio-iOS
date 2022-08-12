//
//  CommentInformation.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import Foundation

struct CommentInformation: Codable {
    let totalCommentCount: Int
    let comments: [Comment]
    
    struct Comment: Codable {
        let id: Int
        let author: Author
        let content, createdDatetime: String
        let likeCount: Int
        let isLiked: Bool
        let repliesCount: Int
    }
    
    struct Author: Codable {
        let id: Int
        let nickname: String
        let profileImageIndex: Int
    }
}
