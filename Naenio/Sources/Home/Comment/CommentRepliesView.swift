//
//  CommentReplyView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/13.
//

import SwiftUI

struct CommentRepliesView: View {
    typealias Comment = CommentInformation.Comment

    @State var text: String = ""
    @Binding var isPresented: Bool
    
    let comment: Comment
    let replies: [Comment]
    
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
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        
                        Text("답글")
                            .font(.semoBold(size: 16))
                        
                        Spacer()
                        
                        CloseButton(action: { isPresented = false })
                            .frame(width: 12, height: 12)
                    }
                    
                    CustomDivider()
                    CommentContentView(comment: comment)
                    
                    ForEach(replies, id: \.id) { reply in
                        CustomDivider()
                            .frame(width: UIScreen.main.bounds.width)

                        CommentContentView(comment: reply)
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
//        .redacted(reason: viewModel.status == .loading ? .placeholder : [])
    }
}
