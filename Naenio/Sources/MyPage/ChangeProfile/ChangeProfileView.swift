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
                    Spacer()
                }
                .foregroundColor(.white)
            }
        }
        .navigationBarHidden(true)
    }
}
