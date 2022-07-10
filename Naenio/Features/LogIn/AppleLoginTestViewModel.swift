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
        status = .inProgress
        
        guard let _ = loginManager.requestLogin() else {
            status = .fail
            return
        }
        
        status = .done
    }
    
    init(_ loginManager: AppleLoginManager = AppleLoginManager()) {
        self.loginManager = loginManager
    }
}

extension AppleLoginTestViewModel {
    enum Status: String {
        case waiting
        case inProgress
        case done
        case fail
    }
}
