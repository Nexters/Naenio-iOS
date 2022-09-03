//
//  OpenedByLinkFullView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/18.
//

import SwiftUI

struct OpenedByLinkFullView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = FullViewModel()
    private let postId: Int
    
    var body: some View {
        ZStack {
            FullView(post: $viewModel.post, viewModel: self.viewModel, showComments: true)
                .redacted(reason: viewModel.status == .inProgress || viewModel.status == .waiting ? .placeholder : [])
                .environmentObject(userManager)
        }
        .onAppear {
            viewModel.getOnePost(with: postId)
        }
    }
    
    init(postId: Int) {
        self.postId = postId
    }
}
