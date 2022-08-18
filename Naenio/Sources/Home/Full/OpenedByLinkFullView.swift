//
//  OpenedByLinkFullView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/18.
//

import SwiftUI

struct OpenedByLinkFullView: View {
    @ObservedObject var viewModel = FullViewModel()
    private let postId: Int
    
    var body: some View {
        ZStack {
            FullView(post: $viewModel.post)
                .redacted(reason: viewModel.status == .inProgress || viewModel.status == .waiting ? .placeholder : [])
        }
        .onAppear {
            viewModel.getOnePost(with: postId)
        }
    }
    
    init(postId: Int) {
        self.postId = postId
    }
}
