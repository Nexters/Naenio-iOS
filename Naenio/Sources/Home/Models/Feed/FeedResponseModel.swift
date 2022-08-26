//
//  FeedResponseModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/13.
//

struct FeedResponseModel: ModelType {
    let posts: [Post]
    
    struct Post: ModelType, Identifiable {
        let id: Int
        let commentCount: Int
        let author: Author
        let title: String
        let content: String
        var choices: [Choice]
    }
}

struct Author: ModelType {
    let id: Int
    let nickname: String?
    let profileImageIndex: Int?
}
