//
//  VotesViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/18.
//

import SwiftUI
import RxSwift

class VotesViewModel: ObservableObject {
    @Published var status: NetworkStatus<VoteResponseModel> = .waiting
    
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    func requestVote(postId: Int, choiceId: Int?) {
        status = .inProgress
        
        bag = DisposeBag() // Cancel previous works
        
        guard let choiceId = choiceId else { return }
        let voteRequestModel = VoteRequestModel(postId: postId, choiceId: choiceId)
        
        print(postId, choiceId)
        
        RequestService<VoteResponseModel>.request(api: .postVote(voteRequestModel))
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let self = self else { return }
                    
                    print("Success on vote: \(result)")
                    
                    self.status = .done(result: result)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }
            )
            .disposed(by: bag)
        
    }
}
