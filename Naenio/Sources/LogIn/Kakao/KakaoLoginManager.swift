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
    func requestLoginToServer(with result: OAuthToken) -> Single<UserInformation> {
        let token = result.accessToken
        let loginInfo = LoginRequestInformation(authToken: token, authServiceType: "KAKAO")
        
        return submitUserInformationToServer(with: loginInfo)
    }
    
    private func submitUserInformationToServer(with info: LoginRequestInformation) -> Single<UserInformation> {
        let sequence = NaenioAPI.login(info)
            .request()
            .map { response -> UserInformation in
                let data = response.data
                let decoded = try NaenioAPI.jsonDecoder.decode(UserInformation.self, from: data)
                
                return decoded
            }
        
        return sequence
    }
}
