//
//  CommentReplyView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/13.
//

import SwiftUI

struct CommentRepliesView: View {
    typealias Comment = CommentInformation.Comment

    @ObservedObject var viewModel = CommentRepliesViewModel()
    @State var text: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let comment: Comment
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.card
                .ignoresSafeArea()
            
            ScrollView {
                // Placeholder
                Rectangle()
                    .fill(.clear)
                    .frame(height: 30)
                
                LazyVStack(spacing: 18) {
                    // Sheet's header
                    HStack {
                        Button(action: popNavigation) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Text("답글")
                            .font(.semoBold(size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        CloseButton(action: popNavigation)
                            .frame(width: 12, height: 12)
                    }
                    
                    CustomDivider()
                    
                    CommentContentView(comment: comment, isReply: true)
                    
                    CustomDivider()

                    ForEach(viewModel.replies, id: \.id) { reply in
                        HStack {
                            Text("😀")
                                .padding(3)
                                .opacity(0)
                            
                            CommentContentView(comment: reply, isReply: true)
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
            }
            
            // Keyboard
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    Text("😀")
                        .padding(3)
                        .background(Circle().fill(Color.green.opacity(0.2)))
                    
                    TextView(placeholder: "댓글 추가", content: $text, characterLimit: 200, showLimit: false)
                        .background(Color.card)
                        .cornerRadius(3)
                        .frame(height: 32)
                    
                    Button(action: {}) {
                        Text("게시")
                            .font(.semoBold(size: 14))
                            .foregroundColor(.naenioGray)
                    }
               }
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .background(Color.background.ignoresSafeArea())
            }
        }
        .navigationBarHidden(true)
        .redacted(reason: viewModel.status == .loading ? .placeholder : [])
        .onAppear {
            viewModel.requestComments()
        }
    }
}

extension CommentRepliesView {
    func popNavigation() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
