//
//  HomeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import Foundation
import RxSwift

class HomeViewModel: ObservableObject {
    // Published vars
    @Published var category: Category = .entire // ???: 마지막 선택 저장하는 것도 낫 배드 - using @SceneStorage
    @Published var posts: [Post]
    @Published var currentPage: Int = 0
    @Published var status: Status = .waiting
    
    // vars and lets
    private let pagingValue = 10
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .utility)
    
    // !!!: 테스트용
    func requestPosts() {
        bag = DisposeBag() // Cancel running tasks by initializing the bag
        status = .inProgress
                
        getPostDisposable(category: self.category)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newPosts in
                    guard let self = self else { return }
                    print("Success requestPosts")
                    self.posts = newPosts
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
        status = .inProgress
        
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
        self.posts = emptyPosts
        self.requestPosts()
    }
}

// !!!: 테스트용
extension HomeViewModel {
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
        
        var path: String?
        switch category {
        case .entire:
            path = Bundle.main.path(forResource: "MockPostList", ofType: "json")
        case .participated:
            path = Bundle.main.path(forResource: "MockPostParticipatedList", ofType: "json")
        case .wrote:
            path = Bundle.main.path(forResource: "MockPostWroteList", ofType: "json")
        }
        
        guard let path = path else {
            print("Invalid path")
            return Observable.of(posts).asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
        }
        
        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            let decoded = try JSONDecoder().decode([Post].self, from: data)
            (0..<10).forEach { _ in
                posts.append(MockPostGenerator.generate())
            }
            
            return Observable.of(posts).asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
        } catch let error {
            print(error)
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
        case inProgress
        case done
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .inProgress:
                return "In progres..."
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
