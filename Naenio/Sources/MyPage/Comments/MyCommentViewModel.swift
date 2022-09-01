//
//  MyCommentViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI
import RxSwift

class MyCommentViewModel: ObservableObject {
    @Published var status: NetworkStatus<Bool> = .waiting
    @Published var comments: [MyComment]?
    
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler(qos: .utility)
    
    func getMyComments(lastCommentId: Int? = nil) {
        status = .inProgress
        
        let myCommentRequest = MyCommentRequest(size: 10, lastCommentId: nil)
        RequestService<MyCommentResponseModel>.request(api: .getMyComment(myCommentRequest))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    
                    self.comments = response.comments ?? []
                    self.status = .done(result: true)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    print(error)
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
}
