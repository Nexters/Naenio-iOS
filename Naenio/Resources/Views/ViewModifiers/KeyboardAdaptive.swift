//
//  KeyboardAdaptive.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI
import Combine

/// Keyboard가 나타날 때 view를 위로 밀어 올립니다
///
/// 현재 `VStack`에만 적용 가능하며 `ScrollView`는 테스트되지 않았음.
struct KeyboardAdaptive: ViewModifier {
    let offset: CGFloat
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .offset(x: 0, y: -self.bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                    
                    // Optimized number -> 하드코딩 맘에 안들긴 한데 일단 이렇게 막아놓기로
//                    if keyboardHeight == 0 {
//                        self.bottomPadding = 0
//                    } else {
//                        self.bottomPadding = offset
//                    }
                }
                .animation(.spring())
        }
    }
}
