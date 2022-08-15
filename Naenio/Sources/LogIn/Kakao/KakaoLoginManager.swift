//
//  KakaoLogin.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxSwift

/// 카카오 서버에서 받아온 인증 정보를 네니오 서버에 보내기 위한 작업을 하는 클래스입니다
class KakaoLoginManager {
    let loginRequestService: LoginRequestService
    
    init(_ loginRequestService: LoginRequestService = LoginRequestService()) {
        self.loginRequestService = loginRequestService
    }
    
    func requestLoginToServer(with result: OAuthToken) -> Single<UserInformation> {
        let token = result.accessToken
        let loginInfo = LoginRequestInformation(authToken: token, authServiceType: "KAKAO")
        
        return loginRequestService.submitUserInformationToServer(with: loginInfo)
    }
}
