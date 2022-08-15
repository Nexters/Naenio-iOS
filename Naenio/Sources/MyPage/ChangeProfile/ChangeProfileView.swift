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
                             trailingButton: CustomNavigationButton(title: "등록",
                                                                    disabled: isDisabled,
                                                                    action: { isDisabled.toggle() })) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    Text("Something")
                    
                    TextField("이름을 입력하세요", text: $text)
                        .background(Color.card)
                    
                    Spacer()
                }
                .border(.red)
                .foregroundColor(.white)
            }
        }
        .navigationBarHidden(true)
    }
}
