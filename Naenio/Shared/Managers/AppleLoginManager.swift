//
//  AppleLoginManager.swift
//  Naenio
//
//  Created by enebin on 2022/07/10.
//

import Foundation
import AuthenticationServices

class AppleLoginManager {
    func requestLogin() -> Result<Void, Error> {
        do {
            let info = try authenticateWithAppleOauth()
            try submitUserInformationToServer(with: info)
            
            return .success(())
        }
        catch let error {
            return .failure(error)
        }
    }
    
    private func authenticateWithAppleOauth() throws -> LoginRequestInfo {
        let mockInfo = LoginRequestInfo(accessToken: "")
        /*
         do {
            ...
            < Apple Oauth Routine >
            ...
         } catch let error {
            throw error
         }
        */
        return mockInfo
    }
    
    @discardableResult // !!!: Remove when use
    private func submitUserInformationToServer(with info: LoginRequestInfo) throws -> UserInformation {
        // let userInfo = API.request(with: info)
        let mockInfo = UserInformation(name: "", id: "")
        return mockInfo
    }
}
