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
    @Binding var parentId: Int?
        
    init(isPresented: Binding<Bool>, parentId: Binding<Int?>) {
        self._isPresented = isPresented
        self._parentId = parentId
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.card
                    .ignoresSafeArea()
                
                if viewModel.status == .loading {
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
                            .frame(height: 30)
                        
                        // Sheet's header
                        HStack {
                            CommentCountComponent(count: viewModel.comments.count)
                            
                            Spacer()
                            
                            CloseButton(action: { isPresented = false })
                                .frame(width: 12, height: 12)
                        }
                        
                        ForEach($viewModel.comments) { index, comment in
                            CustomDivider()
                                .fillHorizontal()
                            
                            if let parentId = parentId {
                                CommentContentCell(isPresented: $isPresented,
                                                   toastInfo: $toastInfo,
                                                   comment: comment,
                                                   isReply: false,
                                                   isMine: userManager.getUserId() == comment.wrappedValue.author.id,
                                                   parentId: parentId)
                            } else {
                                ZStack {
                                    Text("⚠️ 일시적인 오류가 발생했습니다")
                                        .font(.semoBold(size: 16))
                                        .foregroundColor(.white)

                                    CommentContentCell(isPresented: $isPresented,
                                                       toastInfo: $toastInfo,
                                                       comment: comment,
                                                       isReply: false,
                                                       isMine: userManager.getUserId() == comment.wrappedValue.author.id,
                                                       parentId: -1)
                                        .blur(radius: 2)
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
                    case .done:
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
                            viewModel.registerComment(self.text, postId: self.parentId)
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
            viewModel.requestComments(postId: self.parentId, isFirstRequest: true)
            viewModel.isFirstRequest = true
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
