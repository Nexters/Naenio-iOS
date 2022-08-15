//
//  PostRequest.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//
struct PostRequestInformation: ModelType {
    let title: String
    let content: String
    let choices: [Choice]
    
    struct Choice: ModelType {
        let name: String
    }
}
