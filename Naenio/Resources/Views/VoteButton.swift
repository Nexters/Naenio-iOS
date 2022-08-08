//
//  VoteButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct VoteButton: View {
    let type: ChoiceType
    let isOpened: Bool
    let choice: Post.Choice
    let action: () -> ()
    
    var body: some View {
        Button(action: self.action) {
            HStack(spacing: 6) {
                Text(type.rawValue + ".")
                    .lineLimit(1)
                    .font(.engBold(size: 16))

                Text(choice.name)
                    .lineLimit(1)
                    .font(.semoBold(size: 16))
            }
            .fillHorizontal()
            .padding(.horizontal, 14)
            .padding(.vertical, 25)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
            .foregroundColor(.white)
            .redacted(reason: choice.isVoted ? [] : .placeholder)
        }
    }
}

extension VoteButton {
    enum ChoiceType: String, Equatable {
        case choiceA
        case choiceB
    }
}

//struct VoteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        VoteButton(choice: .A, text: "이런 저런 이야기")
//    }
//}
