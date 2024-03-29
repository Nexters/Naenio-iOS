//
//  ThemeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/19.
//
//

import SwiftUI
import RxSwift

class ThemeViewModel: ObservableObject {
    // Published vars
    var theme: ThemeType
    
    @Published var posts: [Post]
    @Published var status: Status = .waiting
    @Published var lastPostId: Int?
    
    // vars and lets
    private let pagingSize = 10
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    @objc func refreshThemePosts() {
        self.requestThemePosts(isPulled: true)
    }
    
    func requestThemePosts(isPulled: Bool = true) {
        bag = DisposeBag()
    
        if isPulled {
            status = .loading(.pulled)
        } else {
            status = .loading(.requestPost)
        }
        
        let themeId = self.theme.id

        let themeRequestModel: ThemeRequestModel = ThemeRequestModel(theme: themeId)
        RequestService<FeedResponseModel>.request(api: .getTheme(themeRequestModel))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] post in
                    guard let self = self else { return }
                    
                    let posts = self.transferToPostModel(from: post)
                    self.posts = posts
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    init(theme: ThemeType) {
        self.posts = []
        self.theme = theme
        self.requestThemePosts(isPulled: false)
    }
}

extension ThemeViewModel {
    private func transferToPostModel(from feed: FeedResponseModel) -> [Post] {
        var resultPosts: [Post] = [ ]
        feed.posts.forEach { post in
            let voteTotalCount = voteTotalCount(choices: post.choices)
            let newPost = Post(id: post.id, author: post.author, voteCount: voteTotalCount, title: post.title, content: post.content, choices: post.choices, commentCount: post.commentCount)
            
            resultPosts.append(newPost)
        }
        
        return resultPosts
    }
    
    private func voteTotalCount(choices: [Choice]) -> Int {
        guard choices.count == 2 else { return 0 }
        
        return choices[0].voteCount + choices[1].voteCount
    }
    
    private func transferToChoiceModel(from choices: [PostResponseModel.Choice]) -> [Choice] {
        var resultChoices: [Choice] = [ ]
        choices.forEach { choice in
            let newChoice = Choice(id: choice.id, sequence: choice.sequence, name: choice.name, isVoted: false, voteCount: 0)
            resultChoices.append(newChoice)
        }
        
        return resultChoices
    }
}

extension ThemeViewModel {
    enum Status: Equatable {
        static func == (lhs: ThemeViewModel.Status, rhs: ThemeViewModel.Status) -> Bool {
            return lhs.description == rhs.description
        }
        
        case waiting
        case loading(_ reason: WorkType)
        case done
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .loading(let work):
                return "Loading \(work)"
            case .done:
                return "Successfully done"
            case .fail(let error):
                return "Failed with error: \(error.localizedDescription)"
            }
        }
    }
    
    enum WorkType {
        case pulled
        case requestPost
    }
}
