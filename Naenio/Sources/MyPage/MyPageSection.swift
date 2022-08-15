//
//  MyPageForEach.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

/// `VStack`에 라운드 코너를 줌
struct MyPageSection<Content>: View where Content: View {
    let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .cornerRadius(10)
    }
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
}
