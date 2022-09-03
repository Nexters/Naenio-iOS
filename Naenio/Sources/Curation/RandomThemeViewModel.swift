//
//  RandomThemeViewModel.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/28.
//

import SwiftUI
import RxSwift

class RandomThemeViewModel: ObservableObject {
    @Published var status: Status = .waiting
    @Published var post: Post = MockPostGenerator.generate(sortType: .wrote)
    
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    @objc func requestRandomThemePosts() {
        bag = DisposeBag()
        status = .loading

        RequestService<RandomPostResponseModel>.request(api: .getRandomPost)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] postResponse in
                    guard let self = self else { return }
                    
                    print("Success requestPosts")
                    self.post = postResponse.toPost()
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    init() {
        requestRandomThemePosts()
    }
}

extension RandomThemeViewModel {
    func getImage(of index: Int) -> Image {
        return ProfileImages.getImage(of: index)
    }
}

extension RandomThemeViewModel {
    enum Status: Equatable {
        static func == (lhs: RandomThemeViewModel.Status, rhs: RandomThemeViewModel.Status) -> Bool {
            return lhs.description == rhs.description
        }
        
        case waiting
        case loading
        case done
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .loading:
                return "Loading comments"
            case .done:
                return "Successfully done"
            case .fail(let error):
                return "Failed with error: \(error.localizedDescription)"
            }
        }
    }
}
