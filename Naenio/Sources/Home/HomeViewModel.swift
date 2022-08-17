//
//  HomeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import SwiftUI
import RxSwift

class HomeViewModel: ObservableObject {
    // Published vars
    @Published var sortType: SortType?
    @Published var posts: [Post]
    @Published var status: Status = .waiting
    @Published var lastPostId: Int?
    let postRequestService: PostRequestService
    let feedRequestService: FeedRequestService
    let voteRequestService: VoteRequestService
    
    // vars and lets
    private let pagingSize = 10
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    func vote(index: Int, sequence: Int, postId: Int, choiceId: Int) {
        var post = self.posts[index]
        var choice = post.choices[sequence]
        var otherChoice = post.choices[sequence == 0 ? 1 : 0]
        guard !choice.isVoted else { return }
        
        status = .loading(reason: "postVote")
        
        let voteRequestModel = VoteRequestModel(postId: postId, choiceId: choiceId)
        RequestService<VoteResponseModel>.request(api: .postVote(voteRequestModel))
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    
                    withAnimation {
                        choice.isVoted = true
                        
                        choice.voteCount += 1
                        
                        if otherChoice.isVoted {
                            otherChoice.isVoted = false
                            otherChoice.voteCount -= 1
                        } else {
                            post.voteCount += 1
                        }
                        
                        post.choices[sequence == 0 ? 0 : 1] = choice
                        post.choices[sequence == 0 ? 1 : 0] = otherChoice
                        
                        self.posts[index] = post
                    }
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestPosts")
                })
            .disposed(by: bag)
        
    }
    
    func register(postRequesInformation: PostRequestInformation) {
        status = .loading(reason: "sameCategoryPosts")
        
        postRequestService.postPost(with: postRequesInformation)
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] post in
                    guard let self = self else { return }
                    
                    withAnimation {
                        let author = Author(id: post.memberId, nickname: UserManager.shared.getNickName(), profileImageIndex: UserManager.shared.getProfileImagesIndex())
                        let nextChoices = self.transferToChoiceModel(from: post.choices)
                        let newPost = Post(id: post.id, author: author, voteCount: 0, title: post.title, content: post.content ?? "", choices: nextChoices, commentCount: 0)
                        
                        self.posts.insert(newPost, at: 0)
                    }
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestPosts")
                })
            .disposed(by: bag)
    }
    
    func voteTotalCount(choices: [Choice]) -> Int {
        guard choices.count == 2 else { return 0 }
        
        return choices[0].voteCount + choices[1].voteCount
    }
    
    func transferToPostModel(from feed: FeedResponseModel) -> [Post] {
        var resultPosts: [Post] = [ ]
        feed.posts.forEach { post in
            let voteTotalCount = voteTotalCount(choices: post.choices)
            let newPost = Post(id: post.id, author: post.author, voteCount: voteTotalCount, title: post.title, content: post.content, choices: post.choices, commentCount: post.commentCount)
            
            resultPosts.append(newPost)
        }
        
        return resultPosts
    }
    
    func transferToChoiceModel(from choices: [PostResponseModel.Choice]) -> [Choice] {
        var resultChoices: [Choice] = [ ]
        choices.forEach { choice in
            let newChoice = Choice(id: choice.id, sequence: choice.sequence, name: choice.name, isVoted: false, voteCount: 0)
            resultChoices.append(newChoice)
        }
        
        return resultChoices
    }
    
    @objc func requestPosts() {
        bag = DisposeBag()
        status = .loading(reason: "differentCategoryPosts")
        
        let feedRequestInformation: FeedRequestInformation = FeedRequestInformation(size: pagingSize, lastPostId: nil, sortType: sortType?.rawValue)
        
        feedRequestService.getFeed(with: feedRequestInformation)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newFeed in
                    guard let self = self else { return }
                    
                    print("Success requestPosts")
                    let posts = self.transferToPostModel(from: newFeed)
                    self.posts = posts
                    self.changeLastPostId()
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestPosts")
                })
            .disposed(by: bag)
    }
    
    func requestMorePosts() {
        bag = DisposeBag()
        status = .loading(reason: "sameCategoryPosts")
        
        let feedRequestInformation: FeedRequestInformation = FeedRequestInformation(size: pagingSize, lastPostId: 10, sortType: sortType?.rawValue)
        
        feedRequestService.getFeed(with: feedRequestInformation)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] feed in
                    guard let self = self else { return }
                    
                    print("Success requestPosts")
                    let newPost = self.transferToPostModel(from: feed)
                    self.posts.append(contentsOf: newPost)
                    self.changeLastPostId()

                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestMorePosts")
                })
            .disposed(by: bag)

    }
    
    func changeLastPostId() {
        if !self.posts.isEmpty {
            self.lastPostId = self.posts[self.posts.count - 1].id
        }
    }
    
    // !!!: 테스트용
    @objc func testRequestPosts() {
        bag = DisposeBag()
        status = .loading(reason: "differentCategoryPosts")
                
        getPostDisposable(sortType: self.sortType! )
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newPosts in
                    guard let self = self else { return }
                    
                    print("Success requestPosts")
                    
                    // For empty view test
                    if self.sortType == .wrote {
                        self.posts = []
                    } else {
                        self.posts = newPosts
                    }
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestPosts")
                })
            .disposed(by: bag)
    }
    
    // !!!: 테스트용
    func testRequestMorePosts() {
        bag = DisposeBag() // Cancel running tasks by initializing the bag
        status = .loading(reason: "sameCategoryPosts")
        
        getPostDisposable(sortType: self.sortType!)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newPosts in
                    guard let self = self else { return }
                    print("Success requestMorePosts")
                    
                    self.posts.append(contentsOf: newPosts)
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestMorePosts")
                })
            .disposed(by: bag)
    }

    init(_ postRequestService: PostRequestService = PostRequestService(),
         _ feedRequestService: FeedRequestService = FeedRequestService(),
         _ voteRequestService: VoteRequestService = VoteRequestService()
    ) {
        self.postRequestService = postRequestService
        self.feedRequestService = feedRequestService
        self.voteRequestService = voteRequestService
        
        self.posts = []
        self.requestPosts()
    }
}

// !!!: 테스트용
extension HomeViewModel {
    private func registerNewPost(_ postRequest: PostRequestInformation) -> Single<Post> {
        let mockPost = MockPostGenerator.generate(with: postRequest)
        let observable = Observable.just(mockPost)
        
        return observable.asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    private func getPost() -> [Post] {
        let posts = [Post]()
        
        guard let path = Bundle.main.path(forResource: "MockPostList", ofType: "json") else {
            print("Invalid path")
            return posts
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoded = try JSONDecoder().decode([Post].self, from: data)
            
            return decoded
        } catch let error {
            print(error)
        }
        
        return posts
    }
    
    private func getPostDisposable(sortType: SortType) -> Single<[Post]> {
        var posts = [Post]()
        
//        var path: String?
//        switch category {
//        case .entire:
//            path = Bundle.main.path(forResource: "MockPostList", ofType: "json")
//        case .participated:
//            path = Bundle.main.path(forResource: "MockPostParticipatedList", ofType: "json")
//        case .wrote:
//            path = Bundle.main.path(forResource: "MockPostWroteList", ofType: "json")
//        }
//
//        guard let path = path else {
//            print("Invalid path")
//            return Observable.of(posts).asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
//        }
//
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            let decoded = try JSONDecoder().decode([Post].self, from: data)
//
//
//            return Observable.of(posts).asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
//        } catch let error {
//            print(error)
//        }
        (0..<10).forEach { _ in
            posts.append(MockPostGenerator.generate(sortType: sortType))
        }
        
        return Observable.of(posts).asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
}

extension HomeViewModel {
    enum Status: Equatable {
        static func == (lhs: HomeViewModel.Status, rhs: HomeViewModel.Status) -> Bool {
            return lhs.description == rhs.description
        }
        
        case waiting
        case loading(reason: String)
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

}
