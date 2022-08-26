//
//  MyPageCell.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

/// 마이페이지 셀의 디자인을 담당
struct MyPageCell<Leading, Trailing>: View where Leading: View, Trailing: View {
    let leadingView: Leading
    let trailingView: Trailing
    
    var body: some View {
        HStack {
            leadingView
            
            Spacer()
            
            trailingView
        }
        .padding(.horizontal, 24)
        .frame(height: 57)
        .fillHorizontal()
        .background(Color.card)
        .foregroundColor(.white)
    }
    
    init(@ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.leadingView = leading()
        self.trailingView = trailing()
    }
}
