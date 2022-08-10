//
//  Post.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let author: Author
    var voteCount: Int
    let title: String
    let content: String
    var choices: [Choice]
    var commentCount: Int
    
    struct Author: Codable {
        let id: Int
        let nickname: String
        let profileImageIndex: Int
    }

    struct Choice: Codable {
        let id: Int
        let sequence: Int
        let name: String
        var isVoted: Bool
        var voteCount: Int
    }
}
