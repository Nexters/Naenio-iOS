//
//  Post.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import Foundation

struct Post: ModelType, Identifiable, Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let author: Author
    var voteCount: Int
    let title: String
    let content: String
    var choices: [Choice]
    var commentCount: Int
}

struct Choice: ModelType {
    let id: Int
    let sequence: Int
    let name: String
    var isVoted: Bool
    var voteCount: Int
}
