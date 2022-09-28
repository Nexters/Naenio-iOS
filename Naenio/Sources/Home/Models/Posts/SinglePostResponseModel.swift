//
//  SinglePostResponseModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/18.
//

struct SinglePostResponseModel: ModelType {
    static func == (lhs: SinglePostResponseModel, rhs: SinglePostResponseModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let author: AuthorResponse
    let title, content: String
    let choices: [ChoiceResponse]
    let commentCount: Int

    // MARK: - Author
    struct AuthorResponse: Codable {
        let id: Int
        let nickname: String?
        let profileImageIndex: Int?
    }

    // MARK: - Choice
    struct ChoiceResponse: Codable {
        let id, sequence: Int
        let name: String
        let isVoted: Bool
        let voteCount: Int
        
        func toChoice() -> Choice {
            return Choice(id: self.id, sequence: self.sequence, name: self.name, isVoted: self.isVoted, voteCount: self.voteCount)
        }
    }
}

extension SinglePostResponseModel {
    func toPost() -> Post {
        let author = Author(
            id: self.author.id,
            nickname: self.author.nickname,
            profileImageIndex: self.author.profileImageIndex
        )
        
        let voteCount = (self.choices.first?.voteCount ?? 0) + (self.choices.last?.voteCount ?? 0)
        
        let choices = self.choices.map {
            $0.toChoice()
        }
        
        return Post(id: self.id,
                    author: author,
                    voteCount: voteCount,
                    title: self.title,
                    content: self.content,
                    choices: choices,
                    commentCount: self.commentCount
        )
    }
}

