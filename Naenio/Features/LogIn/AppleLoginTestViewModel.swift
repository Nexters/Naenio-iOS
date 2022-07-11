//
//  AppleLoginTestViewModels.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI

class AppleLoginTestViewModel: ObservableObject {
    // Dependencies
    let loginManager: AppleLoginManager
    
    // Published vars
    @Published var status: Status = .waiting
    
    func requestLogin() {
        switch loginManager.requestLogin() {
        case .success(()):
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
