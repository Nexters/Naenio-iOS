//
//  ProfileChangeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI
import RxSwift

class ProfileChangeViewModel: ObservableObject {
    // Dependencies
    let userManager: UserManager = UserManager.shared
    
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
    
    func submitChangeNicknameRequest(_ nickname: String) {
        if nickname.isEmpty {
            return
        }
        
        RequestService<NicknameResponseModel>.request(api: .putNickname(nickname))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    print(nickname)
                    self.userManager.updateNickName(response.nickname)
                    self.status = .done(result: true)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
        
        // TODO: 서버 API 붙여야 함!!!
        // if networkingSuccessed {
        self.status = .done(result: true) // 임시
        // }
        
    }
    
    func submitChangeProfileRequest(_ index: Int) {
        if index < 0 || index >= ProfileImages.count {
            return
        }
        
        RequestService<IndexResponseModel>.request(api: .putProfileIndex(index))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    
                    self.userManager.updateProfileImageIndex(response.profileImageIndex)
                    self.status = .done(result: true)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
        
        // TODO: 서버 API 붙여야 함!!!
        // if networkingSuccessed {
        self.status = .done(result: true) // 임시
        // }
        
    }
    
    init() {
        print("init")
    }
    deinit {
        print("deinit")
    }
}
