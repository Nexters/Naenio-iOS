//
//  NewRandomThemeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/09/14.
//

import SwiftUI
import RxSwift

class NewRandomThemeViewModel: ObservableObject {
    @Published var post: Post
    @Published var status: NetworkStatus<Bool> = .waiting
    
    // vars and lets
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    @objc func requestRandomThemePosts() {
        bag = DisposeBag()
        status = .inProgress

        RequestService<RandomPostResponseModel>.request(api: .getRandomPost)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] postResponse in
                    guard let self = self else { return }
                    self.post = postResponse.toPost()
                    
                    self.status = .done(result: true)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    init() {
        self.post = MockPostGenerator.generateEmptyPost()
        self.requestRandomThemePosts()
    }
}
