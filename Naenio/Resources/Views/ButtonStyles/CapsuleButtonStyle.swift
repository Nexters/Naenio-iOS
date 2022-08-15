//
//  CapsuleButtonStyle.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    var height: CGFloat = 43
    var fontSize: CGFloat
    var bgColor: Color
    var textColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .foregroundColor(textColor)
            .frame(height: height)
            .background(Capsule().fill(bgColor))
            .opacity(configuration.isPressed ? 0.3 : 1)
            .font(.semoBold(size: fontSize))
    }
}
