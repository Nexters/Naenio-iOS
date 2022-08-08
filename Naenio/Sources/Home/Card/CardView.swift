//
//  CardView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    @EnvironmentObject var sourceObject: HomeViewModel
    let index: Int
    let post: Post

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
                
                Text("🗳 \(post.voteCount)명 투표")
                    .font(.medium(size: 14))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text("\(post.title)")
                    .lineLimit(2)
                    .lineSpacing(7)
                    .font(.semoBold(size: 22))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(post.content)")
                    .lineLimit(2)
                    .lineSpacing(5)
                    .font(.medium(size: 16))
                    .foregroundColor(.naenioGray)
                    .padding(.bottom, 18)
                
                VotesView(index: index, choices: post.choices)
                    .environmentObject(sourceObject)
            }
            .padding(.horizontal, 20)
            .padding(.top, 27)
            .padding(.bottom, 16)

            Button(action: {}) {
                HStack(spacing: 6) {
                    Text("💬 댓글")
                        .font(.semoBold(size: 16))
                        .foregroundColor(.white)
                    
                    Text("\(post.commentCount)개")
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
    
    init(index: Int, post: Post) {
        self.index = index
        self.post = post
        self.viewModel = CardViewModel()
    }
}

extension CardView {
    var profile: some View {
        HStack {
            Text("😀")
                .padding(3)
                .background(Circle().fill(Color.green.opacity(0.2)))
            
            Text("\(post.author.nickname)")
                .font(.medium(size: 16))
        }
    }
}

// struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(viewModel: CardViewModel(post: emptyPosts[0]))
//    }
// }
