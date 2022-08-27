//
//  MyCommentViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

class MyCommentViewModel: ObservableObject {
    @Published var comments: [MyComment] = []
}

// MARK: - Comment
struct MyComment: Codable {
    let id: Int
    let content: String
    let post: MyCommentPost
        
    // MARK: - Post
    struct MyCommentPost: Codable {
        let id: Int
        let author: MyCommentAuthor
        let title: String
    }

    // MARK: - Author
    struct MyCommentAuthor: Codable {
        let id: Int
        let nickname: String
        let profileImageIndex: Int
    }
}


