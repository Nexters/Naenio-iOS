//
//  AppleLoginTestViewModels.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI
import AuthenticationServices

class AppleLoginTestViewModel: ObservableObject {
    // Dependencies
    let loginManager: AppleLoginManager
    
    // Published vars
    @Published var status: Status = .waiting
    
    func handleLoginResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResult):
            requestLoginToServer(with: authResult)
            status = .done
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    private func requestLoginToServer(with result: ASAuthorization) {
        guard let info = result.credential as? ASAuthorizationAppleIDCredential,
              let token = info.identityToken,
              let stringToken = String(data: token, encoding: .utf8)
        else {
            status = .fail(with: URLError(.cannotDecodeRawData)) // TODO: TBD
            return
        }
        
        let tokenWrapper = LoginRequestInfo(accessToken: stringToken)
        
        switch loginManager.requestLogin(with: tokenWrapper) {
        case .success(let user):
            print(user)
            
            // Save(user)
            
            status = .done
        case .failure(let error):
            status = .fail(with: error)
        }
    }
    
    init(_ loginManager: AppleLoginManager = AppleLoginManager()) {
        self.loginManager = loginManager
    }
}

extension AppleLoginTestViewModel {
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
}
