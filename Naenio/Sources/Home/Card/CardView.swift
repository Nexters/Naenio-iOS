//
//  CardView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI
import Combine
import AlertState

struct CardView: View {
    typealias Action = () -> Void
    
    @State var voteHappened = false
    
    @AlertState<SystemAlert> var alertState
    
    // Injected values
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel: CardViewModel
    @Binding var post: Post
    let action: Action // 시트 보여주기 용
    let deletedAction: Action?
    
    var body: some View {
        ZStack {
            Color.card
            
            if voteHappened {
                LottieView(isPlaying: $voteHappened, animation: LottieAnimations.confettiAnimation)
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
                        
                        // MARK: 공유버튼
                        shareButton
                        
                        // MARK: 신고 / 삭제 버튼
                        reportOrDeleteButton
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
        .onChange(of: post.choices) { [oldValue = post.choices] newValue in
            voteHappened = didVoteChange(oldValue, newValue)
        }
        .onChange(of: viewModel.status) { status in
            switch status {
            case .done(let workType):
                switch workType {
                case .report:
                    // TODO: 신고하기 성공 피드백
                    break
                case .delete:
                    // MARK: 삭제하기 성공 피드백
                    withAnimation {
                        (deletedAction ?? {})()
                    }
                    // TODO: Alert
                }
            case .fail(with: let error):
                alertState = .errorHappend(error: error)
                break
            default:
                break
            }
        }
        .showAlert(with: $alertState)
    }
    
    init(_ viewModel: CardViewModel = CardViewModel(),
         post: Binding<Post>,
         action: @escaping Action,
         deletedAction: Action? = nil) {
        self.viewModel = viewModel
        self._post = post
        self.action = action
        self.deletedAction = deletedAction
    }
}

extension CardView {
    private func didVoteChange(_ lhs: [Choice], _ rhs: [Choice]) -> Bool {
        let firstArr = lhs.sorted{ $0.sequence < $1.sequence }
        let secondArr = rhs.sorted{ $0.sequence < $1.sequence }
        
        var isVoteChanged: Bool
        if firstArr.first?.isVoted == secondArr.first?.isVoted,
           firstArr.last?.isVoted == secondArr.last?.isVoted {
            isVoteChanged = false
        } else {
            isVoteChanged = true
        }
        
        return isVoteChanged
    }
    
    var profile: some View {
        HStack {
            if let profileImageIndex = post.author.profileImageIndex {
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
    
    var shareButton: some View {
        Button(action: {
            ShareManager.share(url: URL(string: "https://naenio.shop/posts/\(post.id)"))
        }) {
            Image("icon_share")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 14, height: 14)
        }
    }
    
    var reportOrDeleteButton: some View {
        Button(action: {
            let notificationInfo: LowSheetNotification
            if post.author.id == userManager.getUserId() {
                notificationInfo = LowSheetNotification(title: "삭제하기", action: {
                    viewModel.delete(postId: post.id)
                })
            } else {
                notificationInfo = LowSheetNotification(title: "신고하기", action: {
                    viewModel.report(authorId: post.author.id, type: .post)
                })
            }
            
            // 메인 뷰에 하단시트 신호 보내기
            NotificationCenter.default.postLowSheetNotification(with: notificationInfo)
        }) {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: 90))
                .foregroundColor(.white)
                .frame(width: 14, height: 14)
        }
    }
}
