//
//  OpenedByLinkFullView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/18.
//

import SwiftUI
import AlertState

struct OpenedByLinkFullView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = FullViewModel()
    
    @AlertState<SystemAlert> var alertState
    
    private let postId: Int
    var showCommentFirst: Bool
    
    var body: some View {
        ZStack {
            FullView(self.viewModel,
                     post: $viewModel.post,
                     showCommentFirst: self.showCommentFirst)
            .redacted(reason: viewModel.status == .inProgress || viewModel.status == .waiting ? .placeholder : [])
            .environmentObject(userManager)
        }
        .onAppear {
            viewModel.getOnePost(with: postId)
        }
        .onChange(of: viewModel.status) { status in
            switch status {
            case .fail(with: let error):
                alertState = .errorHappend(error: error)
            default:
                break
            }
        }
        .showAlert(with: $alertState)
    }
    
    init(postId: Int, showCommentFirst: Bool) {
        self.postId = postId
        self.showCommentFirst = showCommentFirst
    }
}
