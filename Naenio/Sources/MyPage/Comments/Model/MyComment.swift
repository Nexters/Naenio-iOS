//
//  WrittenComment.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/09/01.
//

import Foundation

// MARK: - Comment
struct MyComment: Decodable, Identifiable {
    let id: Int
    let content: String
    let post: MyCommentPost
        
    // MARK: - Post
    struct MyCommentPost: Decodable {
        let id: Int
        let author: MyCommentAuthor
        let title: String
    }

    // MARK: - Author
    struct MyCommentAuthor: Decodable {
        let id: Int
        let nickname: String?
        let profileImageIndex: Int?
    }
}
