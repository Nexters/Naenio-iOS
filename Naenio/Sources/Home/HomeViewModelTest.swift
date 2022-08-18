//
//  HomeViewModelTest.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/18.
//
import Foundation
import RxSwift

// !!!: 테스트용
extension HomeViewModel {
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
