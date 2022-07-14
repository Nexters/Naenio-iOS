//
//  AppleLoginTestViewModels.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI
import AuthenticationServices

class LoginTestViewModel: ObservableObject {
    // Dependencies
    let appleLoginManager: AppleLoginManager
    let kakaoLoginManager: KakaoLoginManager
    
    // Published vars
    @Published var status: Status = .waiting
    
    // For apple
    func handleAppleLoginResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResult):
            requestAppleLoginToServer(with: authResult)
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    private func requestAppleLoginToServer(with result: ASAuthorization) {
        switch appleLoginManager.requestLoginToServer(with: result) {
        case .success(let user):
            print(user)     
            // Save(user)
            
            status = .done
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    
    // For kakao
    func handleKakaoLoginResult(result: Result<KakaoAuthorization, Error>) {
        switch result {
        case .success(let authResult):
            requestKakaoLoginToServer(with: authResult)
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    private func requestKakaoLoginToServer(with result: KakaoAuthorization) {
        switch kakaoLoginManager.requestLoginToServer(with: result) {
        case .success(let user):
            print(user)
            // Save(user)
            
            status = .done
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    init(_ appleLoginManager: AppleLoginManager = AppleLoginManager(),
         _ kakaoLoginManager: KakaoLoginManager = KakaoLoginManager()) {
        self.appleLoginManager = appleLoginManager
        self.kakaoLoginManager = kakaoLoginManager
    }
}

extension LoginTestViewModel {
    enum Status {
        case waiting
        case inProgress
        case done
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .inProgress:
                return "In progres..."
            case .done:
                return "Successfully done"
            case .fail(let error):
                return "Failed with error: \(error.localizedDescription)"
            }
        }
    }
    
    enum Channel {
        case Kakao
        case Apple
    }
    
}
