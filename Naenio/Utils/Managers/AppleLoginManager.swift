//
//  AppleLoginManager.swift
//  Naenio
//
//  Created by enebin on 2022/07/10.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject {
    func requestLoginToServer(with result: ASAuthorization) -> Result<UserInformation, Error> {
        do {
            guard let info = result.credential as? ASAuthorizationAppleIDCredential,
                  let token = info.identityToken,
                  let stringToken = String(data: token, encoding: .utf8)
            else {
                // TODO: Replace here
                throw URLError(.cannotDecodeRawData)
            }
            
            let loginInfo = LoginRequestInfo(accessToken: stringToken)
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

