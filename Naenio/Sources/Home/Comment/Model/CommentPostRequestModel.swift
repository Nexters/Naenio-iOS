//
//  CommentRequestInformation.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/14.
//

import Foundation

struct CommentPostRequestModel: ModelType {
    let parentID: Int
    let parentType, content: String

    enum CodingKeys: String, CodingKey {
        case parentID = "parentId"
        case parentType, content
    }
}
