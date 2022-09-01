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
                            ForEach(viewModel.comments!) { comment in
                                NavigationLink(destination: LazyView(
                                    OpenedByLinkFullView(postId: comment.post.id))
                                    .environmentObject(userManager)
                                ) {
                                    MyCommentCell(myComment: comment)
                                        .frame(height: 184)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                    }
                }
            }
            .onAppear {
                viewModel.getMyComments()
            }
        }
        .navigationBarHidden(true)
    
    }
}
