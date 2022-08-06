//
//  FullView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/05.
//

import SwiftUI

struct FullView: View {
    @ObservedObject var viewModel: FullViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                profile
                    .foregroundColor(.white)
                    .padding(.bottom, 24)
                
                Text("🗳 \(viewModel.post.voteCount)명 투표")
                    .font(.medium(size: 14))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text("\(viewModel.post.title)")
                    .lineLimit(2)
                    .lineSpacing(7)
                    .font(.semoBold(size: 22))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(viewModel.post.content)")
                    .lineLimit(2)
                    .lineSpacing(5)
                    .font(.medium(size: 16))
                    .foregroundColor(.naenioGray)
                    .padding(.bottom, 18)
                
                Spacer()
                
                ZStack {
                    VStack(spacing: 18) {
                        VoteButton(choice: .A, text: "\(viewModel.post.choices.first?.name as Any)")
                        
                        VoteButton(choice: .B, text: "\(viewModel.post.choices.last?.name as Any)")
                    }
                    
                    Text("VS")
                        .font(.engSemiBold(size: 16)) // ???: 제플린 따라서 18로 넣으면 잘 안맞음(https://zpl.io/dxjxvn7)
                        .background(
                            Circle().fill(Color.white)
                                .frame(width: 34, height: 34)
                        )
                }
                .padding(.bottom, 32)
                
                commentButton
                    .fillHorizontal()
                    .padding(.bottom, 160)
                
            }
            .padding(.horizontal, 40)
            .padding(.top, 27)
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                moreInformationButton
            }
        }
    }
}

extension FullView {
    var backButton: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .font(.body.weight(.medium))
                .foregroundColor(.white)
                .frame(width: 18, height: 18)
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
                .frame(width: 18, height: 18)
        }
    }
    
    var profile: some View {
        HStack {
            Text("😀")
                .padding(3)
                .background(Circle().fill(Color.green.opacity(0.2)))
            
            Text("\(viewModel.post.author.nickname)")
                .font(.medium(size: 16))
        }
    }
    
    var commentButton: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Text("💬 댓글")
                    .font(.semoBold(size: 16))
                    .foregroundColor(.white)
                
                Text("\(viewModel.post.commentCount)개")
                    .font(.regular(size: 16))
                    .foregroundColor(.naenioGray)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(height: 46)
            .fillHorizontal()
            .background(Color.black)
        }
        .mask(RoundedRectangle(cornerRadius: 12))
    }
}

//struct FullView_Previews: PreviewProvider {
//    static var previews: some View {
//        FullView(viewModel: FullViewModel(post: <#Post#>))
//    }
//}
