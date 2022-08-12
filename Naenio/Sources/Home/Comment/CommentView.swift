//
//  CommentView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel = CommentViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if viewModel.status == .loading {
                LoadingIndicator()
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.comments, id: \.id) { comment in
                        Text(comment.content)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            viewModel.requestComments()
        }
    }
}
