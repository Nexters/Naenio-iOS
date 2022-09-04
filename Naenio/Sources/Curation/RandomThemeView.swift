//
//  RandomThemeView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/28.
//

import SwiftUI
import Combine

struct RandomThemeView: View {
    private let theme: ThemeType
    
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = RandomThemeViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var voteHappened: Bool = false
    @State var showComments: Bool = false
    @State var showMoreInfoSheet: Bool = false
    @State var selectedPostId: Int? = nil
    
    @State var attempts: Int = 0
    
    var body: some View {
        ZStack {
            if viewModel.status == .loading {
                LoadingIndicator()
                    .zIndex(1)
            }
            
            LinearGradient(gradient: Gradient(colors: theme.data.backgroundColorList),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
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
                
                Text("🗳 \(viewModel.post.voteCount)명 투표")
                    .font(.medium(size: 14))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text("\(viewModel.post.title)")
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(7)
                    .font(.semoBold(size: 20))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(viewModel.post.content)")
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(5)
                    .font(.medium(size: 14))
                    .foregroundColor(.naenioGray)
                    .padding(.bottom, 18)
                
                Spacer()
                
                VotesView(post: $viewModel.post)
                    .padding(.bottom, 32)
                    .zIndex(1)
                
                commentButton
                    .fillHorizontal()
                    .padding(.bottom, 160)
                
                HStack {
                    Spacer()
                    updateRandomPostButton
                }
            }
            .modifier(Shake(animatableData: CGFloat(attempts)))
            .padding(.horizontal, 40)
            .padding(.top, 27)
            .padding(.bottom, 16)
        }
        .sheet(isPresented: $showComments) {
            CommentView(isPresented: $showComments, parentPost: $viewModel.post, parentPostId: $selectedPostId)
        }
        .onChange(of: viewModel.post.choices) { _ in
            voteHappened = true
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(theme.data.title)
                    .font(.engBold(size: 22))
                    .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                moreInformationButton
            }
        }
        .navigationTitle(theme.data.title)
    }
    
    init(_ theme: ThemeType) {
        self.theme = theme
    }
}

extension RandomThemeView {
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
    
    var shareButton: some View {
        Button(action: {
            ShareManager.share(url: URL(string: "https://naenio.shop/posts/\($selectedPostId)"))
        }) {
            Image("icon_share")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 14, height: 14)
        }
    }
    
    var moreInformationButton: some View {
        Button(action: {
            showMoreInfoSheet = true
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
    
    var updateRandomPostButton: some View {
        Button(action: {
            // MARK: 굴러가는 느낌의 haptic 적용을 위해 error type 채택. 실제 기능 상의 error를 뜻하는 바는 아님.
            // TODO: Custom haptic 적용이 가능한지 확인 필요
            HapticManager.shared.notification(type: .error)
            viewModel.requestRandomThemePosts()
            withAnimation(.default) {
                self.attempts += 1
            }}
        ) {
            Image("random_button")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
        }
        .onShake {
            HapticManager.shared.notification(type: .error)
            viewModel.requestRandomThemePosts()
            withAnimation(.default) {
                self.attempts += 1
            }
        }
    }
    
    var profile: some View {
        HStack {
            if let profileImageIndex = viewModel.post.author.profileImageIndex {
                ProfileImages.getImage(of: profileImageIndex)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 24, height: 24)
            }
            
            Text("\(viewModel.post.author.nickname ?? "(알 수 없음)")")
                .font(.medium(size: 16))
        }
    }
    
    var commentButton: some View {
        Button(action: {
            selectedPostId = viewModel.post.id
            showComments = true
        }) {
            HStack(spacing: 6) {
                Text("💬 댓글")
                    .font(.semoBold(size: 16))
                    .foregroundColor(.white)
                
                Text("\(viewModel.post.commentCount)개")
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
