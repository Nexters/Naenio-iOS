//
//  CommentView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel = CommentViewModel()
    @Binding var isPresented: Bool

    var body: some View {
        ZStack() {
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
        }
        .redacted(reason: viewModel.status == .loading ? .placeholder : [])
        .onAppear {
            viewModel.requestComments()
        }
    }
}
