//
//  CardView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct CardView: View {
    @StateObject var viewModel: CardViewModel
//     Redact
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
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
                
                Text("🗳 \(viewModel.post.voteCount)명 투표")
                    .font(.medium(size: 14))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text("\(viewModel.post.title)")
                    .lineLimit(2)
                    .lineSpacing(7)
                    .font(.semoBold(size: 22))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(viewModel.post.content)")
                    .lineLimit(2)
                    .lineSpacing(5)
                    .font(.medium(size: 16))
                    .foregroundColor(.naenioGray)
                    .padding(.bottom, 18)
                
                ZStack {
                    VStack(spacing: 18) {
                        VoteButton(choice: .A, text: "\(viewModel.post.choices.first?.name as Any)")
                        
                        VoteButton(choice: .B, text: "\(viewModel.post.choices.last?.name as Any)")
                    }
                    
                    Text("VS")
                        .font(.engSemiBold(size: 16)) // ???: 제플린 따라서 18로 넣으면 잘 안맞음(https://zpl.io/dxjxvn7)
                        .background(
                            Circle().fill(Color.white)
                                .frame(width: 34, height: 34)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 27)
            .padding(.bottom, 16)

            Button(action: {}) {
                HStack(spacing: 6) {
                    Text("💬 댓글")
                        .font(.semoBold(size: 16))
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.post.commentCount)개")
                        .font(.regular(size: 16))
                        .foregroundColor(.naenioGray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .fillHorizontal()
                .background(Color.subCard)
            }
        }
        .fillScreen()
        .background(Color.card)
        .mask(RoundedRectangle(cornerRadius: 16))
    }
}

//    init(user: User) {
//        self.viewModel = CardViewModel(user: user)
//    }

extension CardView {
    var profile: some View {
        HStack {
            Text("😀")
                .padding(3)
                .background(Circle().fill(Color.green.opacity(0.2)))
            
            Text("\(viewModel.post.author.nickname)")
                .font(.medium(size: 16))
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(viewModel: CardViewModel(post: emptyPosts[0]))
    }
}
