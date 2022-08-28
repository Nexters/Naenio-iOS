//
//  CustomNavigationBackButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI

struct CustomNavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let action: (() -> Void)?

    var body: some View {
        Button(action: {
            if let action = action {
                action()
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(height: 24)
                .foregroundColor(.white)
        }
    }
    
    init(action: (() -> Void)? = nil) {
        self.action = action
    }
}
