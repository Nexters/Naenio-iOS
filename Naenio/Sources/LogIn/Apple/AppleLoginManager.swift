//
//  AppleLoginManager.swift
//  Naenio
//
//  Created by enebin on 2022/07/10.
//

import Foundation
import AuthenticationServices

/// 애플 서버에서 받아온 인증 정보를 네니오 서버에 보내기 위한 작업을 하는 클래스입니다
class AppleLoginManager{
    /// 애플 서버에서 받아온 인증정보 `ASAuthorization`를 네니오 서버 요구사항에 맞춰 가공합니다
    ///
    /// - Parameters:
    ///     - with :  `ASAuthorization`를 전달해야 합니다.
    ///     `ASAuthorization`는 애플 서버에서 로그인 성공 시 제공하는 인증 정보 타입입니다
    ///
    /// - Returns:`UserInformation`와 `Error`가 담긴 `Result`타입을 리턴합니다.
    ///      `UserInformation`는 서버의 검증 작업이 성공한 후 제공되는 유저 인증 정보 타입입니다.
    func requestLoginToServer(with result: ASAuthorization) -> Result<UserInformation, Error> {
        do {
            guard let info = result.credential as? ASAuthorizationAppleIDCredential,
                  let token = info.identityToken,
                  let stringToken = String(data: token, encoding: .utf8)
            else {
                // TODO: Replace here
                throw URLError(.cannotDecodeRawData)
            }
            
            // TODO: LoginRequestInformation May contain authorization codes
            let loginInfo = LoginRequestInformation(authToken: stringToken, authServiceType: "APPLE")
            let userInfo = try submitUserInformationToServer(with: loginInfo)
            
            return .success(userInfo)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    /// API 콜을 요청하는 내부 메소드입니다
    private func submitUserInformationToServer(with info: LoginRequestInformation) throws -> UserInformation {
        // let userInfo = API.request(with: info)
        let mockInfo = UserInformation(token: "")
        return mockInfo
    }
}

