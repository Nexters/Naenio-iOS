//
//  MyCommentsView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct MyCommentView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = MyCommentViewModel()
    
    @State var toastInformation = ToastInformation(isPresented: false, title: "댓글 삭제하기", action: {})
    
    var body: some View {
        
        CustomNavigationView(title: "작성한 댓글") {
            ZStack {
                Color.background.ignoresSafeArea()
                
                if viewModel.status == .inProgress {
                    LoadingIndicator()
                        .zIndex(1)
                }
                
                if viewModel.comments == nil {
                    EmptyView()
                } else if viewModel.comments!.isEmpty {
                    EmptyResultView(description: "아직 작성한 댓글이 없습니다!")
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(Array(viewModel.comments!.enumerated()), id: \.element.id) { index, comment in
                                NavigationLink(destination: LazyView(
                                    OpenedByLinkFullView(postId: comment.post.id))
                                    .environmentObject(userManager)
                                ) {
                                    MyCommentCell(myComment: comment, action: {
                                        self.toastInformation.action = { viewModel.delete(at: index) }
                                        self.toastInformation.isPresented = true
                                    })
                                    .frame(height: 184)
                                    .padding(.horizontal, 20)
                                }
                                .onAppear {
                                    if viewModel.comments!.count == viewModel.pageSize,
                                        index == viewModel.comments!.count - 3 {
                                        let lastCommentId = viewModel.comments!.last!.id
                                        viewModel.getMyComments(lastCommentId: lastCommentId)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toast($toastInformation)
            .onAppear {
                viewModel.getMyComments()
            }
        }
        .navigationBarHidden(true)
        
    }
}
