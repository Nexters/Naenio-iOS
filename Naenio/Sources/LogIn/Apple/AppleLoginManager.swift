//
//  AppleLoginManager.swift
//  Naenio
//
//  Created by enebin on 2022/07/10.
//

import Foundation
import AuthenticationServices
import RxSwift

/// 애플 서버에서 받아온 인증 정보를 네니오 서버에 보내기 위한 작업을 하는 클래스입니다
class AppleLoginManager {
    let loginRequestService: LoginRequestService

    init(_ loginRequestService: LoginRequestService = LoginRequestService()) {
        self.loginRequestService = loginRequestService
    }
    
    /// 애플 서버에서 받아온 인증정보 `ASAuthorization`를 네니오 서버 요구사항에 맞춰 가공합니다
    ///
    /// - Parameters:
    ///     - with :  `ASAuthorization`를 전달해야 합니다.
    ///     `ASAuthorization`는 애플 서버에서 로그인 성공 시 제공하는 인증 정보 타입입니다
    ///
    /// - Returns:`UserInformation`와 `Error`가 담긴 `Single<UserInformation>`타입을 리턴합니다.
    ///      `UserInformation`는 서버의 검증 작업이 성공한 후 제공되는 유저 인증 정보 타입입니다.
    func requestLoginToServer(with result: ASAuthorization) -> Single<UserInformation> {
        if let info = result.credential as? ASAuthorizationAppleIDCredential,
           let token = info.identityToken,
           let stringToken = String(data: token, encoding: .utf8) {
            let loginInfo = LoginRequestInformation(authToken: stringToken, authServiceType: AuthServiceType.apple.rawValue)
            
            UserManager.shared.updateAuthServiceType(AuthServiceType.apple.rawValue)
            return loginRequestService.submitUserInformationToServer(with: loginInfo)
        } else {
            return Single<UserInformation>.error(URLError(.badServerResponse))
        }
    }
}
