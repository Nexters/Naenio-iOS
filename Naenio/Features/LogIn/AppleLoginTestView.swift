//
//  AppleLoginTestView.swift
//  Naenio
//
//  Created by 프라이빗 on 2022/07/10.
//

import SwiftUI

struct AppleLoginTestView: View {
    @ObservedObject var viewModel = AppleLoginTestViewModel()
    
    var body: some View {
        VStack(spacing: 35) {
            Text(viewModel.status.rawValue)
            
            Button(action: { viewModel.requestLogin() }) {
                AppleLoginButton()
                    .frame(width: 280, height: 60)
            }
        }
    }
}

struct AppleLoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginTestView()
    }
}
