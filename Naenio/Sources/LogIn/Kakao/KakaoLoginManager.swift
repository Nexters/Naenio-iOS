//
//  KakaoLogin.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

/// 카카오 서버에서 받아온 인증 정보를 네니오 서버에 보내기 위한 작업을 하는 클래스입니다
class KakaoLoginManager {
    func requestLoginToServer(with result: OAuthToken) -> Result<UserInformation, Error> {
        do {
            let token = result.accessToken
            let loginInfo = LoginRequestInformation(authToken: token, authServiceType: "KAKAO")
            let userInfo = try submitUserInformationToServer(with: loginInfo)
            
            return .success(userInfo)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    private func submitUserInformationToServer(with info: LoginRequestInformation) throws -> UserInformation {
        // let userInfo = API.request(with: info)
        let mockInfo = UserInformation(name: "", id: "")
        return mockInfo
    }
}
