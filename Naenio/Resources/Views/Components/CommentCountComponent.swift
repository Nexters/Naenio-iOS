//
//  CommentCount.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/13.
//

import SwiftUI

struct CommentCountComponent: View {
    let count: Int
    let fontSize: CGFloat = 16
    
    var body: some View {
        HStack(spacing: 6) {
            Text("💬 댓글")
                .font(.semoBold(size: fontSize))
                .foregroundColor(.white)
            
            Text("\(count)개")
                .font(.regular(size: fontSize))
                .foregroundColor(.naenioGray)
        }
    }
}
