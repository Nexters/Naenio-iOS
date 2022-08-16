//
//  ChangeProfileView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI
import BottomSheet

struct ChangeProfileView: View {
    @State var isDisabled: Bool = true
    @State var text: String = ""
    
    var body: some View {
        CustomNavigationView(title: "프로필 변경",
                             button: .trailing(title: "등록", disabled: self.isDisabled, action: { })) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    Text("Something")
                    
                    TextField("이름을 입력하세요", text: $text)
                        .background(Color.card)
                    
                    Spacer()
                }
                .foregroundColor(.white)
            }
        }
        .navigationBarHidden(true)
    }
}
