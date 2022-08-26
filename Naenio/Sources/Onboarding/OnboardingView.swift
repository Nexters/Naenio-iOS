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
    
    @State var showAlert = true
    
    var body: some View {
        ProfileChangeView(showBackButton: false)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("안녕하세요!"), message: Text("네니오를 찾아주셔서 감사해요.\n 이제 닉네임과 프로필 이미지를 선택해주세요!"))
            }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
