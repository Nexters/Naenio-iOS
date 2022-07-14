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
        switch loginManager.requestLoginToServer(with: result) {
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
