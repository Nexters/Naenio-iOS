//
//  MyPageViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI
import RxSwift

class MyPageViewModel: ObservableObject {
    // Dependecies
    private let tokenManager: TokenManager
    
    // lets and vars
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    private let bag = DisposeBag()
    
    @Published var status: NetworkStatus<MyPageStatus> = .waiting
    
    func signOut() {
        tokenManager.deleteToken()
    }
    
    func withdrawal() {
        status = .inProgress
        
        NaenioAPI.deleteAccount.request()
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    self.status = .done(result: .withdrawal)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }
            )
            .disposed(by: bag)
    }
    
    init(_ tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
    }
}

extension MyPageViewModel {
    enum MyPageStatus { // !!!: 얘도 조만간 추상화 갑니다
        case withdrawal
        case user
    }
}
