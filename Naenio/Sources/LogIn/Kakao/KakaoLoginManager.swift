//
//  KakaoLogin.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class KakaoLoginManager {
    func requestLoginToServer(with result: OAuthToken) -> Result<UserInformation, Error> {
        
        return .failure(URLError(.badURL))
    }
}