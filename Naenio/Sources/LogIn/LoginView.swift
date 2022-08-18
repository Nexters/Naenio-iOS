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
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Color.maskGradientVertical
                .ignoresSafeArea()
                .zIndex(0.1)
            
            Color.linearGradientVertical
                .ignoresSafeArea()
                .zIndex(0)
            
            VStack(spacing: 0) {
                Spacer()
                
                Image("logo")
                    .padding(.bottom, 14)
                
                Image("wordmark")
                
//                Text(viewModel.status.description)
                Spacer()
                
                loginButtons
                    .padding(.bottom, 23)
                
                Text("가입 시, 다음 사항에 동의하는 것으로 간주합니다.")
                    .font(.regular(size: 12))
                    .foregroundColor(.mono)
                    .padding(.bottom, 1)

                HStack(spacing: 4) {
                    Text("서비스 이용 약관")
                        .foregroundColor(.naenioGray)
                    Text("및")
                        .foregroundColor(.mono)
                    Text("개인 정보 정책")
                        .foregroundColor(.naenioGray)
                }
                .font(.regular(size: 12))
                .padding(.bottom, 38)
            }
            .zIndex(1)
            .onReceive(viewModel.$status) { result in
                switch result {
                case .done(result: let userInfo):
                    tokenManager.saveToken(userInfo.token)
                    
                    if tokenManager.isTokenAvailable {
                        userManager.updateUserInformation(authServiceType: UserManager.shared.user?.authServiceType ?? "")
                    }
                default:
                    // TODO: Show alert
                    return
                }
            }
        }
    }
}

extension LoginView {
    var loginButtons: some View {
        VStack(spacing: 7) {
            SignInWithKakaoButton { result in
                viewModel.handleKakaoLoginResult(result: result)
            }
            .frame(width: 300, height: 45)
             
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    viewModel.handleAppleLoginResult(result: result)
                }
            )
            .signInWithAppleButtonStyle(.white)
            .frame(width: 300, height: 45)
        }
        .onReceive(viewModel.$status) { result in
            switch result {
            case .done(result: let userInfo):
                tokenManager.saveToken(userInfo.token)
                
                if tokenManager.isTokenAvailable {
                    userManager.updateUserInformation(authServiceType: UserManager.shared.user?.authServiceType ?? "")
                }
            default:
                // TODO: Show alert
                return
            }
        }
    }
}

struct AppleLoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
