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
    func moveUpWhenKeyboardAppear(offset: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive(offset: offset))
    }
    
    
    /// 커스텀 시트를 위해 사용
    func customSheet<C: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        @ViewBuilder content: () -> C
    ) -> CustomSheet<C, Self> {
        CustomSheet(isPresented: isPresented, content: content(), view: self, height: height)
    }
    
    
    /// 반시트
    func halfSheet<C: View>(isPresented: Binding<Bool>,
                            ratio: CGFloat,
                            topBarTitle: String,
                            @ViewBuilder content: @escaping () -> C) -> some View {
        ZStack {
            self
            
            HalfSheet(isPresented: isPresented, ratio: ratio, topBarTitle: topBarTitle, content: content)
        }
    }
    
    
    // 로우시트 with options(인디케이터, 높이, bg)
    @available(*, deprecated, message: "Use .toast instead.")
    func lowSheet<C: View>(isPresented: Binding<Bool>,
                           @ViewBuilder content: @escaping () -> C) -> some View {
        ZStack {
            self
            
            HalfSheet(isPresented: isPresented, content: content)
        }
    }
    
    func toast<T>(_ container: Binding<T>) -> some View where T: ToastContainerType {
        ZStack {
            self
            
            ToastAlertView<T, NewToastInformation>(container)
        }
    }
    
    /// 토스트는 토스트인데 액션이 없어서 alert를 보여주는 함수
    func toastAlert(isPresented: Binding<Bool>,
               title: String) -> some View {
        ZStack {
            self
            
            ToastAlert(isPresented: isPresented, title: title)
                .padding(.bottom, 10)
        }
    }
    
    
    /// 특정 코너만 라운드 주고 싶을 때 사용
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func fullBackground(imageName: String) -> some View {
        return background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}
