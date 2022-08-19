//
//  FullView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/05.
//

import SwiftUI
import Combine

struct FullView: View {
    @Binding var post: Post

    @ObservedObject var viewModel = FullViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var didVote: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if didVote {
                LottieView(isPlaying: $didVote, animation: LottieAnimations.confettiAnimation)
                    .allowsHitTesting(false)
                    .fillScreen()
                    .zIndex(0)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                profile
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Text("🗳 \(post.voteCount)명 투표")
                    .font(.medium(size: 14))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text("\(post.title)")
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(7)
                    .font(.semoBold(size: 20))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(post.content)")
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(5)
                    .font(.medium(size: 14))
                    .foregroundColor(.naenioGray)
                    .padding(.bottom, 18)
                
                Spacer()
                
                VotesView(post: $post)
                    .padding(.bottom, 32)
                    .zIndex(1)
                
                commentButton
                    .fillHorizontal()
                    .padding(.bottom, 160)
            }
            .padding(.horizontal, 40)
            .padding(.top, 27)
            .padding(.bottom, 16)
        }
        .onChange(of: post.choices) { _ in
            didVote = true
        }
//        .onReceive(Publishers.didVoteHappen) { id in
//            if id == post.id {
//                didVote = true
//            }
//        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                moreInformationButton
            }
        }
    }
}

extension FullView {
    var backButton: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .font(.body.weight(.medium))
                .foregroundColor(.white)
                .frame(width: 18, height: 18)
        }
    }
    
    var moreInformationButton: some View {
        Button(action: {
            let notification = LowSheetNotification(postId: post.id)
            NotificationCenter.default.postLowSheetNotification(with: notification)
        }) {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .font(.body.weight(.medium))
                .rotationEffect(Angle(degrees: 90))
                .foregroundColor(.white)
                .frame(width: 18, height: 18)
        }
    }
    
    var profile: some View {
        HStack {
            Text("😀")
                .padding(3)
                .background(Circle().fill(Color.green.opacity(0.2)))
            
            Text("\(post.author.nickname ?? "(알 수 없음)")")
                .font(.medium(size: 16))
        }
    }
    
    var commentButton: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Text("💬 댓글")
                    .font(.semoBold(size: 16))
                    .foregroundColor(.white)
                
                Text("\(post.commentCount)개")
                    .font(.regular(size: 16))
                    .foregroundColor(.naenioGray)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(height: 46)
            .fillHorizontal()
            .background(Color.black)
        }
        .mask(RoundedRectangle(cornerRadius: 12))
    }
}

// struct FullView_Previews: PreviewProvider {
//    static var previews: some View {
//        FullView(viewModel: FullViewModel(post: <#Post#>))
//    }
// }
