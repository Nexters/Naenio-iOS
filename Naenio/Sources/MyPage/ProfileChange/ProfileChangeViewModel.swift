//
//  ProfileChangeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI
import RxSwift

class ProfileChangeViewModel: ObservableObject {
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    @Published var status: NetworkStatus<Bool> = .waiting
    
    func getIsNicknameDuplicated(nickname: String) {
        RequestService<AvailableNicknameResponseModel>.request(api: .getIsNicknameAvailable(nickname))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    let isAvailable = response.exist
                    
                    print("Success getIsNicknameDuplicated")
                    
                    self.status = .done(result: isAvailable)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    func submitProfileChangeRequest(nickname: String, index: Int) {
        let nicknameSequence = RequestService<NicknameResponseModel>.request(api: .putNickname(nickname))
        let profileImageSequence = RequestService<IndexResponseModel>.request(api: .putProfileIndex(index))
        
        Single.zip(nicknameSequence, profileImageSequence)
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe (
                onSuccess: { [weak self] _, _ in // Would not use response data
                    guard let self = self else { return }
                    
                    self.status = .done(result: true)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    init() {
        print("init")
    }
}
