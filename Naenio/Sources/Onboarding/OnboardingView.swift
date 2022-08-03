//
//  OnboardingView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var tokenManager: TokenManager
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        Button(action: { userManager.user }) {
            Text("Hello, World!(On boarding)")
        }
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
