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

                        CommentContentView(comment: comment)
                    }
                }
                .padding(.horizontal, 20)
            }
            .introspectScrollView { scrollView in
                scrollView.keyboardDismissMode = .interactive
            }
            
            TextField("댓글 추가", text: $text)
                .background(Color.white)
                .frame(height: 32)
                .fillHorizontal()
                .zIndex(1)
        }
        .redacted(reason: viewModel.status == .loading ? .placeholder : [])
        .onAppear {
            viewModel.requestComments()
        }
    }
}
