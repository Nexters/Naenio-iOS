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
                                              content: "눈은 푹푹 나리고 나는 나타샤를 생각하고 나타샤가 아니 올 리 없다.",
                                              post: MyComment.MyCommentPost(id: 123123,
                                                                            author: MyComment.MyCommentAuthor(id: 123123, nickname: "호날두", profileImageIndex: 1),
                                                                            title: "가난한 내가 아름다운 나타샤를 사랑해서 오늘밤은 푹푹 눈이 나린다. 나타샤를 사랑은 하고 눈은 푹푹 날리고 나는 혼자 쓸쓸히 앉어 소주를 마신다 소주를 마시며 생각한다. 나타샤와 나는 눈이 푹푹 쌓이는 밤 흰 당나귀 타고 산골로 가자 출출이 우는 깊은 산골로 가 마가리에 살자")
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
