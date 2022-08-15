//
//  View + Exetension.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/06.
//

import SwiftUI

extension View {
    /// View를 화면 전체에 꽉 채웁니다
    func fillScreen() -> some View {
        return self.modifier(FillScreen())
    }
    
    /// View를 양 옆으로 꽉 채웁니다
    func fillHorizontal() -> some View {
        return self.modifier(FillHorizontal())
    }
    
    /// Keyboard가 나타날 때 view를 위로 밀어 올립니다
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
