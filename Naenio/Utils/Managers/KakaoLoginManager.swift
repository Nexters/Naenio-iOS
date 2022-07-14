//
//  KakaoLogin.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import KakaoSDKAuth
import KakaoSDKCommon

class KakaoLoginManager {
    func requestLoginToServer(with result: KakaoAuthorization) -> Result<UserInformation, Error> {
        return .failure(URLError(.badURL))
    }
}
