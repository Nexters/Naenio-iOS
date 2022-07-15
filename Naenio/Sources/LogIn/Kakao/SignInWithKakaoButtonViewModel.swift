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

class SignInWithKakaoButtonViewModel {
    func requestLoginToKakaoServer(_ completion: @escaping (Result<OAuthToken, Error>) -> Void) {
        print(UserApi.isKakaoTalkLoginAvailable())
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
                    
                    print(oauthToken)
                    completion(.success(oauthToken))
                }
            }
        }
        else { // 카카오톡 미설치시 웹뷰 로그인 이용 유도
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    guard let oauthToken = oauthToken else {
                        completion(.failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    print(oauthToken)
                    completion(.success(oauthToken))
                }
            }
        }
        
    }
}
