//
//  ChangeProfileView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI
import Introspect

struct ChangeProfileView: View {
    // @EnvironmentObject userManager: UserManager
    
    @State var isPresented: Bool = false
    @State var profileImage: Image = Image("profile_dog1")
    @State var isDisabled: Bool = true
    @State var text: String = ""
    
    var body: some View {
        CustomNavigationView(title: "프로필 변경",
                             button: .trailing(title: "등록", disabled: self.isDisabled, action: { isPresented.toggle() })) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    // Profile image
                    profileImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 97, height: 97)
                        .overlay(Image("pencil"), alignment: .bottomTrailing)
                        .padding(.top, 60)
                        .padding(.bottom, 42)
                    
                    TextField("", text: $text)
                        .foregroundColor(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 20)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white))
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .foregroundColor(.white)
            }
        }
        .halfSheet(isPresented: $isPresented, ratio: 0.55) {
            Text("SS")
        }
        .navigationBarHidden(true)
    }
}
