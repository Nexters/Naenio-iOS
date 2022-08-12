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
    @Published var category: Category = .entire // ???: 마지막 선택 저장하는 것도 낫 배드 - using @SceneStorage
    @Published var posts: [Post]
    @Published var status: Status = .waiting
    
    // vars and lets
    private let pagingValue = 10
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    func vote(index: Int, sequence: Int) {  // TODO: sequence에 조금 더 견고한 제한이 필요할 듯(Int 말고 enum 같은 걸로)
        var post = self.posts[index]
        var choice = post.choices[sequence]
        var otherChoice = post.choices[sequence == 0 ? 1 : 0]
        
        if choice.isVoted {
            return
        } else {
            choice.isVoted = true
            choice.voteCount += 1
            
            if otherChoice.isVoted {
                otherChoice.isVoted = false
                otherChoice.voteCount -= 1
            } else { // voted first time
                post.voteCount += 1
            }
        }
        
        post.choices[sequence == 0 ? 0 : 1] = choice
        post.choices[sequence == 0 ? 1 : 0] = otherChoice
        
        self.posts[index] = post
    }
    
    // !!!: postPost가 어색해서 일단은 이렇게 네이밍 해놨는데 요기 개선사항 있으면 알려주십셔
    func register(post: PostRequestInformation) {
        status = .loadingSameCategoryPosts
        
        registerNewPost(post)
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] post in
                    guard let self = self else { return }
                    
                    withAnimation {
                        self.posts.insert(post, at: 0)
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
    @objc func requestPosts() {
        bag = DisposeBag() // Cancel running tasks by initializing the bag
        status = .loadingDifferentCategoryPosts
                
        getPostDisposable(category: self.category)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newPosts in
                    guard let self = self else { return }
                    
                    print("Success requestPosts")
                    
                    // For empty view test
                    if self.category == .participated {
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
    func requestMorePosts() {
        bag = DisposeBag() // Cancel running tasks by initializing the bag
        status = .loadingSameCategoryPosts
        
        getPostDisposable(category: self.category)
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

    init() {
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
    
    private func getPostDisposable(category: Category) -> Single<[Post]> {
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
            posts.append(MockPostGenerator.generate(category: category))
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
        case loadingDifferentCategoryPosts
        case loadingSameCategoryPosts
        case done
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .loadingDifferentCategoryPosts:
                return "Loading differnt category's posts"
            case .loadingSameCategoryPosts:
                return "Loading same category's posts"
            case .done:
                return "Successfully done"
            case .fail(let error):
                return "Failed with error: \(error.localizedDescription)"
            }
        }
    }
    
    enum Category: Int {
        case entire = 1
        case participated = 2
        case wrote = 3
    }
}
