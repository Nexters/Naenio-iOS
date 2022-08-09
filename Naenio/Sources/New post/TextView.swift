//
//  TextView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI

struct TextView: View {
    let placeholder: String
    @Binding var content: String
    let characterLimit: Int
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(content == "" ? "무슨 주제를 담아볼까요?" : "")
                .font(.medium(size: 16))
                .foregroundColor(.mono)
                .padding(16)
                .zIndex(1)
            
            ZStack(alignment: .bottomTrailing) {
                RepresentedUITextView(text: $content, limit: characterLimit)
                    .foregroundColor(.white)
                    .background(Color.card)
                    .cornerRadius(8)
                
                Text("\(content.count)/\(characterLimit)")
                    .font(.medium(size: 12))
                    .foregroundColor(.mono)
                    .padding(16)
            }
        }
    }
}
