//
//  MyCommentsView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct MyCommentCell: View {
    let myComment: MyComment
    let action: () -> Void

    var body: some View {
        ZStack {
            Color.card
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        profile
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: action) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(Angle(degrees: 90))
                                .foregroundColor(.white)
                                .frame(width: 14, height: 14)
                        }
                    }
                    
                    Spacer()
                    
                    // 게시글 내용
                    Text("\(myComment.post.title)")
                        .lineLimit(2)
                        .font(.medium(size: 16))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.top, 27)
                .padding(.bottom, 16)
                
                Spacer()
                
                // 내 댓글 내용
                Text(myComment.content)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .font(.medium(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .fillHorizontal()
                    .background(Color.subCard)
                
            }
        }
        .fillScreen()
        .mask(RoundedRectangle(cornerRadius: 16))
    }
}

extension MyCommentCell {
    var profile: some View {
        HStack {
            if let profileImageIndex = myComment.post.author.profileImageIndex {
                ProfileImages.getImage(of: profileImageIndex)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 24, height: 24)
            }
            
            Text("\(myComment.post.author.nickname ?? "(알 수 없음)")")
                .font(.medium(size: 16))
        }
    }
}
