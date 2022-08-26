//
//  CommentContentView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/13.
//

import SwiftUI

struct CommentContentCell: View {
    typealias Comment = CommentModel.Comment
    
    @Binding var isPresented: Bool
    @State var isNavigationActive: Bool = false
    
    let comment: Comment
    let isReply: Bool
    let parentId: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            NavigationLink(destination: CommentRepliesView(isPresented: $isPresented, comment: comment, parentId: comment.id),
                           isActive: $isNavigationActive) {
                EmptyView()
            }

            profileImage
            
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Text(comment.author.nickname ?? "(알 수 없음)")
                        .font(.medium(size: 16))
                        .foregroundColor(.white)

                    Spacer()
                    
                    Text(comment.createdDatetime)
                        .font(.medium(size: 14))
                        .foregroundColor(.naenioGray)
                }

                Text(comment.content)
                    .font(.medium(size: 16))
                    .foregroundColor(.white)
                
                responsiveButtons
                    .foregroundColor(.white)
                    .padding(.bottom, 12)
                
                if comment.repliesCount != 0 && isReply == false {
                    Button(action: {
                        isNavigationActive = true
                        UIApplication.shared.endEditing()
                    }) {
                        Text("답글 \(comment.repliesCount)개")
                            .font(.semoBold(size: 16))
                            .foregroundColor(.naenioBlue)
                    }
                }
            }
            
            moreInformationButton
        }
    }
}

extension CommentContentCell {
    var profileImage: some View {
        Group {
            if let profileImageIndex = comment.author.profileImageIndex { // FIXME:
                ProfileImages.getImage(of: profileImageIndex)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    var responsiveButtons: some View {
        HStack(spacing: 17) {
            Button(action: {}) {
                HStack(spacing: 5) {
                    Image(systemName: "heart")
                    Text("\(comment.likeCount)")
                }
            }
            
            if isReply == false {
                Button(action: {
                    UIApplication.shared.endEditing()
                    isNavigationActive = true
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "text.bubble")
                        Text("\(comment.repliesCount)")
                    }
                }
            }
        }
    }
    
    var moreInformationButton: some View {
        Button(action: {}) {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .font(.body.weight(.medium))
                .rotationEffect(Angle(degrees: 90))
                .foregroundColor(.white)
                .frame(width: 14, height: 14)
        }
    }
}
