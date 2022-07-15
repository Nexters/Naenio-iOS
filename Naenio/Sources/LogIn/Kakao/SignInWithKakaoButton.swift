//
//  SignInWithKakaoButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import SwiftUI
import KakaoSDKAuth

/// 카카오로 로그인 버튼을 생성하는 뷰 입니다
struct SignInWithKakaoButton: View {
    let viewModel = SignInWithKakaoButtonViewModel()
    
    /// 완료 시 토큰을 반환하는 컴플리션 핸들러.  사용자 레이어에서 받아옵니다
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
    
    init(onCompletion: @escaping ((Result<OAuthToken, Error>) -> Void)) {
        self.onCompletion = onCompletion
    }
}
