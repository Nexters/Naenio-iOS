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
    var showLimit = true
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(content == "" ? placeholder : "")
                .font(.medium(size: 16))
                .foregroundColor(.mono)
                .padding(16)
                .zIndex(1)
            
            ZStack(alignment: .bottomTrailing) {
                RepresentedUITextView(text: $content, limit: characterLimit)
                    .foregroundColor(.white)
                    .background(Color.card)
                    .cornerRadius(8)
                
                if showLimit {
                    Text("\(content.count)/\(characterLimit)")
                        .font(.medium(size: 12))
                        .foregroundColor(.mono)
                        .padding(16)
                }
            }
        }
    }
}
