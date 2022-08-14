    //
//  CustomSheetView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/14.
//

import SwiftUI
import Combine

protocol Scrollable {
    
}

struct CustomSheetView<V: View>: View {
    @Binding var isPresented: Bool
    @State var translation: CGFloat = 0
    
    // Make it work in scroll view
    @State var scrollDownOffset: CGFloat = 0
    
    // Content inside the sheet
    let content: V
    
    // View heights
    var height: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {                
                if isPresented {
                    // Dismiss sheet
                    Color.black.opacity(0.3)
                        .onTapGesture {
                            isPresented = false
                        }
                    
                    sheetContent(with: geometry)
                        .transition(.move(edge: .bottom))
                        .offset(x: 0, y: -scrollDownOffset)
                }
            }
            .animation(.easeInOut, value: isPresented)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension CustomSheetView {
    func sheetContent(with geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            Rectangle()
                .fill(Color.card)
                .frame(height: 30)
                .cornerRadius(15, corners: [.topLeft, .topRight])
            
            content
                .frame(
                    width: geometry.size.width,
                    height: translation == 0 ? self.height : geometry.size.height - translation + 50,
                    //                        self.dynamicHeight(with: geometry),
                    alignment: .bottom
                )
                .onReceive(Publishers.keyboardHeight) { value in
                    withAnimation(.easeInOut) {
                        translation = value
                    }
                    
                    print(translation, geometry.size.height)
                }
                .onReceive(Publishers.scrollOffset) { value in
                    // !!!: 매우 위험함. 하나의 스크롤뷰만 퍼블리싱 중임을 보장해야 함
                    if value < 0 {
                        self.scrollDownOffset = value
                    }
                }
                .onReceive(Publishers.scrollVelocity) { value in
                    // !!!: 매우 위험함. 하나의 스크롤뷰만 퍼블리싱 중임을 보장해야 함
                    // 답도 없다 증말 😢😢😢
                    if value < -3.0 && self.scrollDownOffset < 0 {
                        isPresented = false
                    }
                }
                .onAppear {
                    translation = 0
                    scrollDownOffset = 0
                }
                .onDisappear {
                    translation = 0
                    scrollDownOffset = 0
                }
            
            Rectangle()
                .fill(Color.card)
                .frame(height: translation)
        }
    }
}
