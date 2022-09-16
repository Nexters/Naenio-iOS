//
//  AppleLoginTestViewModels.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKAuth
import RxSwift

class LoginViewModel: ObservableObject {
    // Dependencies
    let appleLoginManager: AppleLoginManager
    let kakaoLoginManager: KakaoLoginManager
    let userManager: UserManager
    
    let concurrentQueue = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
    
    // Published vars
    /// 로그인 루틴 처리 상태를 표시
    @Published var status: NetworkStatus<UserInformation> = .waiting
    
    // Private vars
    private let bag = DisposeBag()
    
    // MARK: - For apple
    func handleAppleLoginResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResult):
            requestAppleLoginToServer(with: authResult)
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    private func requestAppleLoginToServer(with result: ASAuthorization) {
        appleLoginManager.requestLoginToServer(with: result).subscribe(on: self.concurrentQueue)
            .subscribe(
                onSuccess: { [weak self] userInfo in
                    guard let self = self else { return }

                    self.status = .done(result: userInfo)
                    self.userManager.updateAuthServiceType(.apple)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                },
                onDisposed: {
                }
            )
            .disposed(by: bag)
    }
    
    // MARK: - For kakao
    func handleKakaoLoginResult(result: Result<OAuthToken, Error>) {
        switch result {
        case .success(let authResult):
            requestKakaoLoginToServer(with: authResult)
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    private func requestKakaoLoginToServer(with result: OAuthToken) {
        kakaoLoginManager.requestLoginToServer(with: result)
            .subscribe(on: self.concurrentQueue)
            .subscribe(
                onSuccess: { [weak self] userInfo in
                    guard let self = self else { return }

                    self.status = .done(result: userInfo)
                    self.userManager.updateAuthServiceType(.kakao)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }
            )
            .disposed(by: bag)
    }
    
    init(_ appleLoginManager: AppleLoginManager = AppleLoginManager(),
         _ kakaoLoginManager: KakaoLoginManager = KakaoLoginManager(),
         _ userManager: UserManager = UserManager.shared)
    {
        self.appleLoginManager = appleLoginManager
        self.kakaoLoginManager = kakaoLoginManager
        self.userManager = userManager
    }
}

