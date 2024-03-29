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
    let choice: Choice?
    let percent: Double?
    
    let action: () -> Void

    var body: some View {
        Button(action: choice == nil ? {} : {
            self.action()
            HapticManager.shared.impact(style: .medium)
        }) {
            HStack(spacing: 6) {
                Text(choice == nil ? "" : type.rawValue + ".")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.engBold(size: 14))

                Text(choice == nil ? "🤔 일시적인 오류가 발생했어요!" : choice!.name)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.semoBold(size: 14))
                
                Spacer()
                
                if isOpened {
                    voteCountsAndPercentage
                }
            }
            .padding(.horizontal, 14)
            .fillHorizontal()
            .frame(height: 72)
            .foregroundColor(.white)
            .background(
                GeometryReader(content: { geometry in
                    Rectangle()
                        .fill(Color.linearGradient)
                        .frame(width: geometry.size.width * CGFloat((isOpened ? (percent ?? 0) : 0) / 100))
                        .transition(.move(edge: .leading))
                        .animation(.interactiveSpring(), value: choice)
                }),
                alignment: .leading)
            .background(Color.black)
            .mask(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.angularGradient,
                            style: StrokeStyle(lineWidth: choice?.isVoted == true ? 1 : 0,
                                               lineCap: .round,
                                               lineJoin: .round)
                           )
            )
        }
    }
}

extension VoteButton {
    var voteCountsAndPercentage: some View {
        VStack(spacing: 4) {
            if let choice = choice, let percent = percent {
                Text("\(Int(round(percent)))%")
                    .font(.semoBold(size: 16))
                
                Text("\(choice.voteCount)명")
                    .lineLimit(1)
                    .font(.semoBold(size: 12))
                    .foregroundColor(.naenioGray)
            }
        }
    }
    
    enum ChoiceType: String, Equatable {
        case choiceA = "A"
        case choiceB = "B"
    }
}

// struct VoteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        VoteButton(choice: .A, text: "이런 저런 이야기")
//    }
// }
