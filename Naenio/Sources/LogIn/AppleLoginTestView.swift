//
//  AppleLoginTestView.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginTestView: View {
    @ObservedObject var viewModel = AppleLoginTestViewModel()
    
    var body: some View {
        VStack(spacing: 35) {
            Text(viewModel.status.description)
            
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    viewModel.handleLoginResult(result: result)
                }
            )
            .frame(width: 280, height: 60)
            
        }
    }
}

struct AppleLoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginTestView()
    }
}
