//
//  CloseButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/13.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                self.action()
                UIApplication.shared.endEditing()
            }
        }) {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
        }
    }
}
