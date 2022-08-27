//
//  MyCommentsView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct MyCommentView: View {
    var body: some View {
        
        CustomNavigationView(title: "작성한 댓글") {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ScrollView {
                    MyCommentCell(myComment:
                                    MyComment(id: 121,
                                              content: "!231",
                                              post: MyComment.MyCommentPost(id: 123123,
                                                                            author: MyComment.MyCommentAuthor(id: 123123, nickname: "!!!", profileImageIndex: 1),
                                                                            title: "!@#!@")
                                             )
                    )
                    .frame(height: 184)
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
    
    }
}
