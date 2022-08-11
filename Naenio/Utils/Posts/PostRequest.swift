//
//  PostRequest.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import Foundation

// MARK: - Post
struct PostRequest: Encodable {
    let title, content: String
    let categoryID: Int
    let choices: [Choice]
    
    // MARK: - Choice
    struct Choice: Codable {
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case title, content
        case categoryID = "categoryId"
        case choices
    }
}
