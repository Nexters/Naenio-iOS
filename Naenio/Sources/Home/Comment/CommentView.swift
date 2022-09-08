//
//  CommentView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI
import Introspect

struct CommentView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject var viewModel = CommentViewModel()
    @ObservedObject var scrollViewHelper = ScrollViewHelper()
    
    @State var text: String = "" // 메시지 작성용
    @State var toastInfo = ToastInformation(isPresented: false, title: "", action: {}) // 리팩토링 시급, 토스트 시트 용 정보 스트럭트
    
    @Binding var isPresented: Bool
    @Binding var parentPostId: Int? // sheet가 SwiftUI에서 버그가 있기 땜에 이걸 같이 넘겨줘야 됨..
    @Binding var parentPost: Post
    
    init(isPresented: Binding<Bool>, parentPost: Binding<Post>, parentPostId: Binding<Int?>) {
        self._isPresented = isPresented
        self._parentPost = parentPost
        self._parentPostId = parentPostId
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.card
                    .ignoresSafeArea()
                
                if viewModel.status == .inProgress {
                    VStack {
                        Spacer()
                        
                        LoadingIndicator()
                            .zIndex(1)
                        
                        Spacer()
                    }
                }
                
                ScrollView {
                    LazyVStack(spacing: 18) {
                        // placeholder
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 8)
                        
                        // Sheet's header
                        HStack {
                            CommentCountComponent(count: viewModel.totalCommentCount)
                            
                            Spacer()
                            
                            CloseButton(action: { isPresented = false })
                                .frame(width: 12, height: 12)
                        }
                        
                        ForEach($viewModel.comments) { index, comment in
                            CustomDivider()
                                .fillHorizontal()
                            
                            CommentContentCell(isPresented: $isPresented,
                                               toastInfo: $toastInfo,
                                               comment: comment,
                                               isReply: false,
                                               isMine: userManager.getUserId() == comment.wrappedValue.author.id,
                                               deletedAction: {
                                viewModel.delete(at: index)
                            })
                            .onAppear {
                                if viewModel.totalCommentCount > viewModel.comments.count && index == viewModel.comments.count - 3 {
                                    guard let lastCommentId = viewModel.comments.last?.id,
                                          let parentPostId = parentPostId
                                    else {
                                        // TODO: 에러 표기
                                        return
                                    }
                                    viewModel.requestComments(postId: parentPostId, lastCommentId: lastCommentId)
                                }
                            }
                        }
                        
                        // Bottom place holder
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 80)
                    }
                    .padding(.horizontal, 20)
                }
                .introspectScrollView { scrollView in
                    scrollView.keyboardDismissMode = .onDrag
                    scrollView.delegate = scrollViewHelper
                }
                .onChange(of: viewModel.status) { status in
                    switch status {
                    case .done(let task):
                        switch task {
                        case .requestComments:
                            break
                        case .register:
                            self.parentPost.commentCount = viewModel.totalCommentCount
                        }
                        scrollViewHelper.refreshController.endRefreshing()
                    case .fail(with: _):
                        scrollViewHelper.refreshController.endRefreshing()
                    default:
                        break
                    }
                }
                
                // 키보드
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        profileImage
                        
                        WrappedTextView(placeholder: "댓글 추가", content: $text, characterLimit: 100, showLimit: false, isTight: true)
                        
                        Button(action: {
                            viewModel.registerComment(self.text, postId: self.parentPostId)
                            UIApplication.shared.endEditing()
                            text = ""
                        }) {
                            Text("게시")
                                .font(.semoBold(size: 14))
                                .foregroundColor(.naenioGray)
                        }
                        .disabled(text.isEmpty)
                        
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
                    .background(Color.background.ignoresSafeArea())
                }
                .frame(height: 60)
            }
            .toast(isPresented: $toastInfo.isPresented, title: toastInfo.title, action: toastInfo.action)
            .navigationBarHidden(true)
        }
        .onAppear {
            guard let parentPostId = parentPostId else {
                // TODO: 에러 표기
                return
            }
            viewModel.requestComments(postId: parentPostId, lastCommentId: nil)
        }
    }
    
    var profileImage: some View {
        let profileImageIndex = userManager.getProfileImagesIndex()
        return ProfileImages.getImage(of: profileImageIndex)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
    }
}
