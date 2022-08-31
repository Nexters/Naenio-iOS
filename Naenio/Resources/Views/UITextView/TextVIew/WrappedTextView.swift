//
//  TextView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI

struct WrappedTextView: View {
    /// 빈 텍스트필드에 나타날 내용(플레이스 홀더)
    let placeholder: String
    
    /// 글 내용
    @Binding var content: String
    
    /// 글자수 제한
    let characterLimit: Int
    
    /// 텍스트필드에 글자수를 보여줄지 결정하는 플래그 변수
    var showLimit = true
    
    /// 텍스트필드의 패딩을 결정하는 플래그 변수
    var isTight: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(content.isEmpty ? placeholder : "")
                .font(.medium(size: 16))
                .foregroundColor(.mono)
                .padding(isTight ? 8 : 16)
                .zIndex(1)
            
            ZStack(alignment: .bottomTrailing) {
                RepresentedUITextView(text: $content, limit: characterLimit, isTight: self.isTight)
                    .foregroundColor(.white)
                    .background(Color.card)
                    .cornerRadius(8)
                
                if showLimit {
                    Text("\(content.count)/\(characterLimit)")
                        .font(.medium(size: 12))
                        .foregroundColor(.mono)
                        .padding(isTight ? 8 : 16)
                }
            }
        }
    }
}
