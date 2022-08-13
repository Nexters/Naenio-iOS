//
//  PostResponseModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/13.
//

import Foundation

struct PostResponseModel: ModelType {
    static func == (lhs: PostResponseModel, rhs: PostResponseModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let memberId: Int
    let title: String
    let content: String
    var choices: [Choice]
    var createdDateTime: String
    var lastModifiedDateTime: String
    
    struct Choice: Codable {
        let id: Int
        let sequence: Int
        let name: String
    }
}
