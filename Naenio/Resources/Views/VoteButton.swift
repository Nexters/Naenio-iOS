//
//  VoteButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct VoteButton: View {
    let choice: Choice
    let text: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Text(choice.rawValue + ".")
                    .font(.engBold(size: 16))
                
                Text(text)
                    .font(.semoBold(size: 14))
            }
            .fillHorizontal()
            .padding(.horizontal, 14)
            .padding(.vertical, 25)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
            .foregroundColor(.white)
        }
    }
}

extension VoteButton {
    enum Choice: String {
        case A
        case B
    }
}

struct VoteButton_Previews: PreviewProvider {
    static var previews: some View {
        VoteButton(choice: .A, text: "이런 저런 이야기")
    }
}
