//
//  CardViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var post: Post
    
    init(post: Post = emptyPost) {
        self.post = emptyPost
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.post = self.getPost()!
        }
    }
}

// TODO: To be removed after attaching real API
extension CardViewModel {
    func getPost() -> Post? {
        guard let path = Bundle.main.path(forResource: "MockPost", ofType: "json") else {
            print("Invalid path")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let post = try JSONDecoder().decode(Post.self, from: data)
            
            return post
        } catch let error {
            print(error)
            return nil
        }
    }

}
