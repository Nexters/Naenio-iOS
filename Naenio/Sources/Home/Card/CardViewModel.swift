//
//  CardViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI
import RxSwift

class CardViewModel: ObservableObject {
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    private let bag = DisposeBag()
    
    @Published var status: NetworkStatus<WorkType> = .waiting
    
    func getImage(of index: Int) -> Image {
        return ProfileImages.getImage(of: index)
    }
    
    func report(authorId: Int, type: CommentType) {
        self.status = .inProgress
        
        // !!!: 회원 탈퇴때도 마찬가진데 응답 바디가 비어있으면 RequestService를 쓸 수가 없음
        // 빈 바디 용 서비스를 또 만들거나 이렇게 해야할 듯
        // RequestService의 이름을 바꿀 필요는 있어 보임(무조건 거쳐가야 되는 느낌이라)
        let reportRequest = ReportRequestModel(targetMemberId: 0, resource: type)
        NaenioAPI.postReport(reportRequest).request()
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.status = .done(result: .report)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
}

extension CardViewModel {
    enum WorkType { // FIXME: 
        case report
    }
}
