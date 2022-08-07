//
//  AppleLoginTestView.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI
import AuthenticationServices

struct LoginTestView: View {
    @ObservedObject var viewModel = LoginTestViewModel()
    var body: some View {
        VStack(spacing: 35) {
            Text(viewModel.status.description)
            SignInWithKakaoButton { result in
                self.viewModel.handleKakaoLoginResult(result: result)
            }
            .frame(width: 280, height: 60)
             
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    self.viewModel.handleAppleLoginResult(result: result)
                }
            )
            .frame(width: 280, height: 60)
            .fullScreenCover(isPresented: $viewModel.presentView ) {
                    // TODO: 회원가입 유무에 따른 화면 분기
                    // SignUpView()
                    MainView()
                }
        }
    }
}

struct AppleLoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        LoginTestView()
    }
}
