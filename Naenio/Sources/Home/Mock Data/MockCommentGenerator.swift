//
//  MockCommentGenerator.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import Foundation

struct MockCommentGenertor {
    typealias Comment = CommentInformation.Comment
    typealias Author = CommentInformation.Author
    
    static func generate() -> CommentInformation {
        return CommentInformation(totalCommentCount: 14, comments: [
            Comment(id: UUID().uuidString.hashValue,
                    author: Author(id: UUID().uuidString.hashValue, nickname: "김만두", profileImageIndex: 1),
                    content: "사랑을 다해 사랑하였노라고 정작 할 말이 남아 있음을 알았을 때",
                    createdDatetime: "22.01.06",
                    likeCount: 12,
                    isLiked: false,
                    repliesCount: 5),
            Comment(id: UUID().uuidString.hashValue,
                    author: Author(id: UUID().uuidString.hashValue, nickname: "김만두", profileImageIndex: 1),
                    content: "당신은 이미 남의 사랑이 되어 있었다. 불러야 할 뜨거운 노래를 가슴으로 죽이며 당신은 멀리로 잃어지고 있었다.",
                    createdDatetime: "22.01.06",
                    likeCount: 12,
                    isLiked: false,
                    repliesCount: 5),
            Comment(id: UUID().uuidString.hashValue,
                    author: Author(id: UUID().uuidString.hashValue, nickname: "김만두", profileImageIndex: 1),
                    content: "다섯 손가락 끝을 잘라 핏물 오선을 그려 혼자라도 외롭지 않을 밤에 울어 보리라",
                    createdDatetime: "22.01.06",
                    likeCount: 12,
                    isLiked: false,
                    repliesCount: 5),
            Comment(id: UUID().uuidString.hashValue,
                    author: Author(id: UUID().uuidString.hashValue, nickname: "김만두", profileImageIndex: 1),
                    content: "한잔은 떠나버린 너를 위하여, 한잔은 이미 초라해진 나를 위하여",
                    createdDatetime: "22.01.06",
                    likeCount: 12,
                    isLiked: false,
                    repliesCount: 5),
            Comment(id: UUID().uuidString.hashValue,
                    author: Author(id: UUID().uuidString.hashValue, nickname: "김만두", profileImageIndex: 1),
                    content: "또 한잔은 너와의 영원한 사랑을 위하여",
                    createdDatetime: "22.01.06",
                    likeCount: 12,
                    isLiked: false,
                    repliesCount: 5),
            Comment(id: UUID().uuidString.hashValue,
                    author: Author(id: UUID().uuidString.hashValue, nickname: "김만두", profileImageIndex: 1),
                    content: "그리고 마지막 한잔은, 미리 알고 정하신 하나님을 위하여",
                    createdDatetime: "22.01.06",
                    likeCount: 12,
                    isLiked: false,
                    repliesCount: 5),
        ])
    }
}

/*
 {
   "totalCommentCount": 0,
   "comments": [
     {
       "id": 0,
       "author": {
         "id": 0,
         "nickname": "string",
         "profileImageIndex": 0
       },
       "content": "string",
       "createdDatetime": "2022-08-12T07:53:39.185Z",
       "likeCount": 0,
       "isLiked": true,
       "repliesCount": 0
     }
   ]
 }
 */
