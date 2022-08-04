//
//  HomeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import Foundation

class HomeViewModel: ObservableObject {
    // Published vars
    @Published var category: Category = .entire // ???: 마지막 선택 저장하는 것도 낫 배드 - using @SceneStorage
    @Published var posts: [Post]
    @Published var currentPage: Int = 0
    
    // !!!: 테스트용
    @discardableResult
    func requestPosts() -> [Post] {
        let newPosts = self.getPost()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.posts.append(contentsOf: newPosts)
        }
        
        return newPosts
    }
    
    // !!!: 테스트용
    @discardableResult
    func requestPosts(page: Int) -> [Post] {
        let newPosts = self.getPost()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.posts.append(contentsOf: newPosts)
        }
        
        return newPosts
    }
    
    init() {
        self.posts = emptyPosts
        self.posts = self.requestPosts(page: 0)
    }
}

// !!!: 테스트용
extension HomeViewModel {
   func getPost() -> [Post] {
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

}

extension HomeViewModel {
    enum Category: Int {
        case entire = 1
        case participated = 2
        case wrote = 3
    }
}
