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
    
    /// 커스텀 시트를 위해 사용
    func customSheet<C: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        @ViewBuilder content: () -> C
    ) -> CustomSheet<C, Self> {
        CustomSheet(isPresented: isPresented, content: content(), view: self, height: height)
    }
    
    /// 특정 코너만 라운드 주고 싶을 때 사용
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
