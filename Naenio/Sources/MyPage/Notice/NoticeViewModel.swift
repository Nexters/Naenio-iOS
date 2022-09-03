//
//  NoticeViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI
import RxSwift

class NoticeViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var status: NetworkStatus<Bool> = .waiting
    
    // lets and vars
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler(qos: .utility)
    
    func getNotices() {
        self.status = .inProgress
        
        RequestService<NoticeResponseModel>.request(api: .getNotice)
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    
                    self.notices = response.notices
                    self.status = .done(result: true)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
}
