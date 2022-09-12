//
//  EmptyResultview.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/19.
//

import SwiftUI

struct EmptyResultView: View {
    let description: String
    
    var body: some View {
        VStack(spacing: 14) {
            Image("empty")
                .resizable()
                .scaledToFit()
                .frame(width: 59, height: 59)
            
            Text(description)
                .font(.medium(size: 18))
                .foregroundColor(.mono)
        }
    }
}
