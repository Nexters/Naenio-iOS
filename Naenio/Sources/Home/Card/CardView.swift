//
//  CardView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI
import Combine

struct CardView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = CardViewModel()
    @State var didVote = false
    
    @Binding var post: Post
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.card
            
            if didVote {
                LottieView(isPlaying: $didVote, animation: LottieAnimations.confettiAnimation)
                    .allowsHitTesting(false)
                    .fillScreen()
                    .zIndex(0)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        profile
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // 신고/공유
                        Button(action: { NotificationCenter.default.postLowSheetNotification(with: LowSheetNotification(postId: post.id)) }) {
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
                        .padding(.vertical, 4)
                        .padding(.bottom, 8)
                    
                    Text("\(post.title)")
                        .lineLimit(2)
                        .lineSpacing(4)
                        .font(.semoBold(size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .padding(.bottom, 10)
                    
                    Text("\(post.content)")
                        .lineLimit(2)
                        .lineSpacing(4)
                        .font(.medium(size: 14))
                        .foregroundColor(.naenioGray)
                        .padding(.bottom, 18)
                    
                    VotesView(post: $post)
                }
                .padding(.horizontal, 20)
                .padding(.top, 27)
                .padding(.bottom, 16)
                
                Button(action: self.action) {
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
        }
        .fillScreen()
        .mask(RoundedRectangle(cornerRadius: 16))
        .onChange(of: post.choices) { _ in
            didVote = true
        }
    }
}

extension CardView {
    var profile: some View {
        HStack {
            if let profileImageIndex = post.author.profileImageIndex { // FIXME:
                viewModel.getImage(of: profileImageIndex)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 24, height: 24)
            }
            
            Text("\(post.author.nickname ?? "(알 수 없음)")")
                .font(.medium(size: 16))
        }
    }
}
