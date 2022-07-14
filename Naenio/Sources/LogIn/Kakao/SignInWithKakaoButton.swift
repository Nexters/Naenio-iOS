//
//  SignInWithKakaoButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/14.
//

import SwiftUI

struct SignInWithKakaoButton: View {
    var body: some View {
        Button(action: {}) {
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
         onCompletion: @escaping ((Result<KakaoAuthorization, Error>) -> Void)) {
        
    }
}
