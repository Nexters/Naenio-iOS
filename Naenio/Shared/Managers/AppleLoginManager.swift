//
//  AppleLoginManager.swift
//  Naenio
//
//  Created by enebin on 2022/07/10.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject {
    func requestLogin(with loginInfo: LoginRequestInfo) -> Result<UserInformation, Error> {
        do {
            let userInfo = try submitUserInformationToServer(with: loginInfo)
            
            return .success(userInfo)
        }
        catch let error {
            return .failure(error)
        }
        
    }
    
    private func submitUserInformationToServer(with info: LoginRequestInfo) throws -> UserInformation {
        // let userInfo = API.request(with: info)
        let mockInfo = UserInformation(name: "", id: "")
        return mockInfo
    }
}

