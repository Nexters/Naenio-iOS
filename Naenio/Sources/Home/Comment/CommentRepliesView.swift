//
//  CommentReplyView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/13.
//

import SwiftUI

struct CommentRepliesView: View {
    typealias Comment = CommentModel.Comment
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isPresented: Bool
    
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = CommentRepliesViewModel()
    @ObservedObject var scrollViewHelper = ScrollViewHelper()
    
    @State var text: String = ""
    @State var toastInfo = ToastInformation(isPresented: false, title: "", action: {}) // 리팩토링 시급, 토스트 시트 용 정보 스트럭트

    @Binding var comment: Comment
    var parentId: Int
    
    var body: some View {
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
                    
                    HStack { // Sheet's header
                        Button(action: {
                            UIApplication.shared.endEditing()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Text("답글")
                            .font(.semoBold(size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        CloseButton(action: { self.isPresented = false })
                            .frame(width: 12, height: 12)
                    }
                    
                    CustomDivider()
                    
                    CommentContentCell(isPresented: $isPresented,
                                       toastInfo: $toastInfo,
                                       comment: $comment,
                                       isReply: true,
                                       isMine: userManager.getUserId() == comment.author.id,
                                       parentId: parentId)
                    
                    CustomDivider()

                    ForEach($viewModel.replies) { _, reply in
                        HStack {
                            Text("▬")   // place holder for inset
                                .padding(3)
                                .opacity(0)
                            
                            CommentContentCell(isPresented: $isPresented,
                                               toastInfo: $toastInfo,
                                               comment: reply,
                                               isReply: true,
                                               isMine: userManager.getUserId() == reply.wrappedValue.author.id,
                                               parentId: parentId)
                        }
                    }
                    
                    // placeholder
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 90)
                }
                .padding(.horizontal, 20)
            }
            .introspectScrollView { scrollView in
                scrollView.keyboardDismissMode = .onDrag
                scrollView.delegate = scrollViewHelper
            }
            
            // Keyboard
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    profileImage
                    
                    WrappedTextView(placeholder: "댓글 추가", content: $text, characterLimit: 100, showLimit: false, isTight: true)
                    
                    Button(action: {
                        viewModel.registerReply(text, postId: parentId)
                        UIApplication.shared.endEditing()
                    }) {
                        Text("게시")
                            .font(.semoBold(size: 14))
                            .foregroundColor(.naenioGray)
                    }
               }
                .frame(height: 32)
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .background(Color.background.ignoresSafeArea())
            }
        }
        .toast(isPresented: $toastInfo.isPresented, title: toastInfo.title, action: toastInfo.action)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.requestCommentReplies(postId: parentId)
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
