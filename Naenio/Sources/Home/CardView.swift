//
//  CardView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct CardView: View {
//    @StateObject var viewModel: CardViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                profile
                    .foregroundColor(.white)

                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: 90))
                        .foregroundColor(.white)
                        .frame(width: 14, height: 14)
                }
            }
            .padding(.bottom, 24)
            
            Text("🗳 123명 투표")
                .font(.medium(size: 14))
                .foregroundColor(.white)
                .padding(.bottom, 8)

            Text("세상에 모든 사람이 날 알아보기 투명 인간 취급 당하기?")
                .lineLimit(2)
                .font(.semoBold(size: 22))
                .foregroundColor(.white)
                .padding(.bottom, 10)

            Text("세상 모든 사람들이 날 알아보지 못하면 슬플 것 같아요.")
                .lineLimit(2)
                .font(.medium(size: 16))
                .foregroundColor(.naenioGray)
                .padding(.bottom, 18)
            
            ZStack {
                VStack(spacing: 18) {
                    VoteButton(choice: .A, text: "세상 모든 사람이 날 알아보기정말")
                    
                    VoteButton(choice: .B, text: "투명 인간 취급당하며 힘들게 살기")
                }
                
                Image("vs")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .background(
                        Circle().fill(Color.white)
                            .frame(width: 34, height: 34)
                    )
            }
        }
        .fillScreen()
        .padding(.horizontal, 20)
        .padding(.top, 27)
        .padding(.bottom, 14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.card))
    }
    
//    init(user: User) {
//        self.viewModel = CardViewModel(user: user)
//    }
}

extension CardView {
    var profile: some View {
        HStack {
            Text("😀")
                .padding(3)
                .background(Circle().fill(Color.green.opacity(0.2)))
            
            Text("김만두")
                .font(.medium(size: 16))
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
