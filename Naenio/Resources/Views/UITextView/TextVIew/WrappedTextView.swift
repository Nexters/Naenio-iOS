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
    
    /// 포커싱 잡혔는지?
    @State var isEditing: Bool
    
    /// 글자수 제한
    let characterLimit: Int
    
    /// 텍스트필드에 글자수를 보여줄지 결정하는 플래그 변수
    let showLimit: Bool
    
    /// 텍스트필드의 패딩을 결정하는 플래그 변수
    let isTight: Bool
    
    /// 개행 허용 여부
    let allowNewline: Bool
    
    /// 공백 허용 여부
    let allowWhiteSpace: Bool
    
    /// 첫빠따
    @State var becomeFirstResponder: Bool
    
    init(placeholder: String,
         content: Binding<String>,
         characterLimit: Int,
         showLimit: Bool = true,
         isTight: Bool = false,
         allowNewline: Bool = true,
         allowWhiteSpace: Bool = true,
         becomeFirstResponder: Bool = false
    ) {
        self.placeholder = placeholder
        self._content = content
        self.isEditing = false
        self.characterLimit = characterLimit
        self.showLimit = showLimit
        self.isTight = isTight
        self.allowNewline = allowNewline
        self.allowWhiteSpace = allowWhiteSpace
        self.becomeFirstResponder = becomeFirstResponder
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(isEditing || !content.isEmpty ? "" : placeholder)
                .font(.medium(size: 16))
                .foregroundColor(.mono)
                .padding(isTight ? 8 : 16)
                .zIndex(1)
            
            ZStack(alignment: .bottomTrailing) {
                RepresentedUITextView(
                    text: $content, isEditing: $isEditing,
                    limit: characterLimit,
                    isTight: self.isTight,
                    allowNewline: self.allowNewline,
                    allowWhiteSpace: self.allowWhiteSpace,
                    becomeFirstResponder: self.$becomeFirstResponder
                )
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
