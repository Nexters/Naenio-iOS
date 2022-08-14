//
//  CustomSheet.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/14.
//

import SwiftUI

struct CustomSheet<C: View, V: View>: View {
    @Binding private var isPresented: Bool
    
    // Views
    private let view: V
    private let content: C
    private let height: CGFloat
    
    var body: some View {
        // Fully overlaying each other
        ZStack(alignment: .center) {
            // Original view
            view
            
            // Bottom sheet
            CustomSheetView(isPresented: $isPresented, content: self.content, height: self.height)
        }
    }
    
    init(
        isPresented: Binding<Bool>,
        content: C,
        view: V,
        height: CGFloat
    ) {
        self._isPresented = isPresented
        self.content = content
        self.view = view
        self.height = height
    }
}
