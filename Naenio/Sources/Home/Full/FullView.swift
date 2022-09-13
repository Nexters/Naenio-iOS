//
//  FullView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/05.
//

import SwiftUI
import Combine
import AlertState

struct FullView: View {
    typealias Action = () -> Void
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var toastInfo = ToastInformation(isPresented: false, title: "", action: {}) // 리팩토링 시급, 토스트 시트 용 정보 스트럭트
    @State private var voteHappened: Bool = false
    @State private var selectedPostId: Int?
    
    @AlertState<SystemAlert> var alertState
    
    // Injected values
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel: FullViewModel
    @Binding var post: Post
    @State var showComments: Bool = false
    var deletedAction: Action?
        
    private let showCommentFirst: Bool
    
    init(
        _ viewModel: FullViewModel = FullViewModel(),
        post: Binding<Post>,
        deletedAction: Action? = nil,
        showCommentFirst: Bool = false
    ) {
        self.viewModel = viewModel
        self._post = post
        self.deletedAction = deletedAction
        self.showCommentFirst = showCommentFirst
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if viewModel.status == .inProgress {
                LoadingIndicator().zIndex(1)
            }
            
            if voteHappened {
                LottieView(isPlaying: $voteHappened, animation: LottieAnimations.confettiAnimation)
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
        .sheet(isPresented: $showComments) {
            CommentView(isPresented: $showComments, parentPost: $post, parentPostId: $selectedPostId)
                .environmentObject(userManager)
        }
        .toast(isPresented: $toastInfo.isPresented, title: toastInfo.title, action: toastInfo.action)
        .onChange(of: viewModel.status) { status in
            switch status {
            case .done(let result):
                switch result {
                case .delete:
                    (deletedAction ?? {})()
                case .singlePost:
                    selectedPostId = post.id
                case .report:
                    NotificationCenter.default.postToastAlertNotification("신고가 접수되었습니다")
                }
            case .fail(let error):
                alertState = .errorHappend(error: error)
                break
            default:
                break
            }
        }
        .showAlert(with: $alertState)
        .onAppear {
            if showCommentFirst {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if case NetworkStatus.done = viewModel.status {
                        selectedPostId = post.id
                        self.showComments = true
                    }
                }
            }
        }
        .onChange(of: post.choices) { _ in
            voteHappened = true
        }
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
            let toastInfo: ToastInformation
            if post.author.id == userManager.getUserId() {
                toastInfo = ToastInformation(isPresented: true, title: "삭제하기", action: {
                    viewModel.delete(postId: post.id)
                })
            } else {
                toastInfo = ToastInformation(isPresented: true, title: "신고하기", action: {
                    viewModel.report(authorId: post.author.id, type: .post)
                })
            }
            
            self.toastInfo = toastInfo
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
    
    var commentButton: some View {
        Button(action: {
            selectedPostId = post.id
            showComments = true
        }) {
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
