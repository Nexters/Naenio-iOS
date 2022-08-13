//
//  CommentView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI
import Introspect

struct CommentView: View {
    @ObservedObject var viewModel = CommentViewModel()
    @State var text: String = ""
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.card
                    .ignoresSafeArea()
                
    //            if viewModel.status == .loading {
    //                LoadingIndicator()
    //            }
                
                ScrollView {
                    // Placeholder
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 30)
                    
                    LazyVStack(spacing: 18) {
                        // Sheet's header
                        HStack {
                            CommentCountComponent(count: viewModel.commentsCount ?? 0)
                             
                            Spacer()
                            
                            CloseButton(action: { isPresented = false })
                                .frame(width: 12, height: 12)
                        }
                        
                        ForEach(viewModel.comments, id: \.id) { comment in
                            CustomDivider()
                                .frame(width: UIScreen.main.bounds.width)

                            CommentContentView(comment: comment, isReply: false)
                        }
                        
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
        }
        .redacted(reason: viewModel.status == .loading ? .placeholder : [])
        .onAppear {
            viewModel.requestComments()
        }
    }
}
