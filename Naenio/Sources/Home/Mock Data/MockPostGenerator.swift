//
//  MockGenerator.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/05.
//

import Foundation

struct MockPostGenerator {
    static func generate(category: HomeViewModel.Category) -> Post {
        var title = ""
        
        switch category {
        case .entire:
            title = "세상에 모든 사람이 날 알아보기 투명 인간 취급 당하기?"
        case .participated:
            title = "추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요.추운 겨울에는 따뜻한 커피와 티를 마셔야지요."
        case .wrote:
            title = "다람쥐 헌 쳇바퀴에 타고파 다람쥐 헌 쳇바퀴에 타고파"
        }
        
        return Post(
            id: UUID().uuidString.hashValue,
            author: Post.Author(id: -1,
                                nickname: "김만두",
                                profileImageIndex: 0),
            voteCount: 132,
            title: title,
            content: "세상 모든 사람들이 날 알아보지 못하면 슬플 것 같아요.",
            choices: [
                Post.Choice(id: 0,
                            sequence: 0,
                            name: "세상 모든 사람이 날 알아보기 정말정말정말",
                            isVoted: false,
                            voteCount: 111),
                Post.Choice(id: 1,
                            sequence: 1,
                            name: "투명 인간 취급당하며 힘들게 살기",
                            isVoted: false,
                            voteCount: 25)
            ],
            commentCount: 111
        )
    }
    
    static func generate(with request: PostRequest) -> Post {
        return Post(
            id: UUID().uuidString.hashValue,
            author: Post.Author(id: -1,
                                nickname: "김만두",
                                profileImageIndex: 0),
            voteCount: 0,
            title: request.title,
            content: request.content,
            choices: [
                Post.Choice(id: 0,
                            sequence: 0,
                            name: request.choices[0].name,
                            isVoted: false,
                            voteCount: 0),
                Post.Choice(id: 1,
                            sequence: 1,
                            name: request.choices[1].name,
                            isVoted: false,
                            voteCount: 0)
            ],
            commentCount: 0
        )
    }
}
