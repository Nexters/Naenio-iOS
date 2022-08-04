//
//  HomeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    // Published vars
    @Published var category: Category = .entire // ???: 마지막 선택 저장하는 것도 낫 배드 - using @SceneStorage
    @Published var posts: [Post] // TODO: Solving data races caused by repeated network calls
    @Published var currentPage: Int = 0
    @Published var status: Status = .waiting
    
    // vars and lets
    private let pagingValue = 10
    
    // !!!: 테스트용
    @discardableResult
    func requestPosts() -> [Post] {
        status = .inProgress
                
        let newPosts = getPost(category: self.category)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.posts = newPosts
            self.status = .done
        }

        return newPosts
    }
    
    // !!!: 테스트용
    @discardableResult
    func requestMorePosts() -> [Post] {
        status = .inProgress
        
        let newPosts = getPost(category: self.category)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.posts.append(contentsOf: newPosts)
            self.status = .done
        }

        return newPosts
    }

    init() {
        self.posts = emptyPosts
        self.posts = self.requestPosts()
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
    
    private func getPost(category: Category) -> [Post] {
        let posts = [Post]()
        
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
