//
//  EmptyPost.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import Foundation

let emptyPost = Post(
    id: -1,
    author: Post.Author(id: 0,
                        nickname: "0000",
                        profileImageIndex: 0),
    voteCount: 0,
    title: "00000000000000000000000000000000000000000000",
    content: "0000000000000000000000000000000000000000",
    choices: [
        Post.Choice(id: 0,
                    sequence: 0,
                    name: "0000000000000000",
                    isSelected: false,
                    voteCount: 111),
        Post.Choice(id: 0,
                    sequence: 0,
                    name: "0000000000000000",
                    isSelected: false,
                    voteCount: 111)
    ],
    commentCount: 111
)
