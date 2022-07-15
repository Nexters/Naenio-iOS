//
//  SignInWithKakaoButtonViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import Combine

class SignInWithKakaoButtonViewModel: ObservableObject {
    func requestLoginToKakaoServer(_ completion: @escaping (Result<OAuthToken, Error>) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    guard let oauthToken = oauthToken else {
                        completion(.failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    completion(.success(oauthToken))
                }
            }
        }
        
    }
}
