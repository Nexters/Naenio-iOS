//
//  AppleLoginTestView.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var tokenManager: TokenManager
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 35) {
            Text(viewModel.status.description)
            
            SignInWithKakaoButton { result in
                viewModel.handleKakaoLoginResult(result: result)
            }
            .frame(width: 280, height: 60)
             
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    viewModel.handleAppleLoginResult(result: result)
                }
            )
            .frame(width: 280, height: 60)
        }
    }
}

struct AppleLoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
