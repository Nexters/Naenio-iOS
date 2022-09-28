//
//  RandomPostResponseModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/28.
//

import Foundation

struct RandomPostResponseModel: ModelType {
    var id: Int
    var author: RandomPostAuthorModel
    var title: String
    var content: String
    var choices: [RandomPostChoiceModel]
    var commentCount: Int
    
    struct RandomPostAuthorModel: ModelType {
        var id: Int
        var nickname: String?
        var profileImageIndex: Int?
        
        func toAuthor() -> Author {
            return Author(id: self.id, nickname: self.nickname, profileImageIndex: self.profileImageIndex)
        }
    }
    
    struct RandomPostChoiceModel: ModelType {
        var id: Int
        var sequence: Int
        var name: String
        var isVoted: Bool
        var voteCount: Int
        
        func toChoice() -> Choice {
            return Choice(id: self.id, sequence: self.sequence, name: self.name, isVoted: self.isVoted, voteCount: self.voteCount)
        }
    }
    
    func toPost() -> Post {
        return Post(id: self.id,
                    author: self.author.toAuthor(),
                    voteCount: voteTotalCount(choices: transferToChoiceModel(from: self.choices)),
                    title: self.title,
                    content: self.content,
                    choices: transferToChoiceModel(from: self.choices),
                    commentCount: self.commentCount)
    }
    
    private func transferToChoiceModel(from choices: [RandomPostResponseModel.RandomPostChoiceModel]) -> [Choice] {
        var resultChoices: [Choice] = [ ]
        choices.forEach { choice in
            let newChoice = choice.toChoice()
            resultChoices.append(newChoice)
        }
        
        return resultChoices
    }
    
    private func voteTotalCount(choices: [Choice]) -> Int {
        guard choices.count == 2 else { return 0 }
        
        return choices[0].voteCount + choices[1].voteCount
    }
}
