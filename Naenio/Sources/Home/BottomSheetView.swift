//
//  BottomSheetView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/14.
//

import SwiftUI
import Combine

struct BottomSheetView: View {
    @Binding var showComments: Bool
    @State var keyboardHeight: CGFloat = 0
    let parentId: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.red)
                .frame(height: 30)
            
            CommentView(isPresented: $showComments, parentId: parentId)
        }
        .onDisappear {
            UIApplication.shared.endEditing()
        }
        .onReceive(Publishers.keyboardHeight) { value in
            withAnimation {
                DispatchQueue.main.async {
                    self.keyboardHeight = value
                }
            }
            
            print(value)
        }
        .fillScreen()
    }
}
