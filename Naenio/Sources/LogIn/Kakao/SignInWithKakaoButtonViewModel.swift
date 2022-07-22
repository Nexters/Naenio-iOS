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
    func login(_ completion: @escaping (Result<OAuthToken, Error>) -> Void) {
        requestLoginToKakaoServer(completion)
    }
    
    /// - Returns: `Result` type을 리턴함.  Kakao SDK 고유 타입인 `OAuthToken`와 Swift native type `Error`를 포함한다.
    private func requestLoginToKakaoServer(_ completion: @escaping (Result<OAuthToken, Error>) -> Void) {
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
