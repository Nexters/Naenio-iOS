//
//  PostRequest.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import Foundation

struct PostRequestInformation: Codable {
    let title: String
    let content: String
    let choices: [Choice]
    
    struct Choice: Codable {
        let name: String
    }
}
