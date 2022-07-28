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
        NavigationView {
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
                
                
                NavigationLink(destination: HapticTestView()) {
                    Text("Go to haptic test")
                }
            }
        }
    }
}

struct AppleLoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        LoginTestView()
    }
}