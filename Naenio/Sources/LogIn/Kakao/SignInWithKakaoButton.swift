//
//  SignInWithKakaoButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import SwiftUI
import KakaoSDKAuth

struct SignInWithKakaoButton: View {
    let viewModel = SignInWithKakaoButtonViewModel()
    
    /// Request 옵션을 받는 클로저(Apple login onRequest처럼)
    let onRequest: (KakaoAuthorizationRequest) -> Void
    /// 완료 시 토큰을 반환하는 컴플리션 핸들러
    let onCompletion: (Result<OAuthToken, Error>) -> Void
    
    var body: some View {
        Button(action: {
            viewModel.requestLoginToKakaoServer(onCompletion)
        }) {
            HStack {
                Text("카카오로 로그인")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(.yellow)
            )
        }
    }
    
    init(onRequest: @escaping (KakaoAuthorizationRequest) -> Void,
         onCompletion: @escaping ((Result<OAuthToken, Error>) -> Void)) {
        self.onRequest = onRequest
        self.onCompletion = onCompletion
    }
}
