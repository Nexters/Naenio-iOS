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
    
    @ObservedObject var viewModel = CommentRepliesViewModel()
    @ObservedObject var scrollViewHelper = ScrollViewHelper()
    
    @State var text: String = ""

    let comment: Comment
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
                    
                    CommentContentCell(isPresented: $isPresented, comment: comment, isReply: true, parentId: parentId)
                    
                    CustomDivider()

                    ForEach(viewModel.replies, id: \.id) { reply in
                        HStack {
                            Text("😀")
                                .padding(3)
                                .opacity(0)
                            
                            CommentContentCell(isPresented: $isPresented, comment: reply, isReply: true, parentId: parentId)
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
                    Text("😀")
                        .padding(3)
                        .background(Circle().fill(Color.green.opacity(0.2)))
                    
                    WrappedTextView(placeholder: "댓글 추가", content: $text, characterLimit: 100, showLimit: false, isTight: true)
                    
                    Button(action: {
                        viewModel.registerReply(self.text, postId: self.parentId)
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
        .navigationBarHidden(true)
        .onAppear {
            viewModel.requestCommentReplies(postId: self.parentId)
        }
    }
}
