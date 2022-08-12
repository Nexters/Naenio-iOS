//
//  NewPostView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI

struct NewPostView: View {
    @EnvironmentObject var sourceObject: HomeViewModel
    @Binding var isPresented: Bool
    
    @State private var postContent = PostContent()    
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .onTapGesture {
                    // Take focus out of text view when tapped
                    UIApplication.shared.endEditing()
                }
            
            VStack(alignment: .leading, spacing: 4) {
                ZStack(alignment: .center) {
                    closeAndRegisterButtons

                    Text("New Post")
                        .font(.engBold(size: 18))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 32)
                
                // MARK: - 투표 주제
                Text("*투표 주제")
                    .foregroundColor(.white)
                    .font(.medium(size: 16))
                
                TextView(placeholder: "무슨 주제를 담아볼까요?", content: $postContent.title, characterLimit: 72)
                    .frame(height: 108)
                    .padding(.bottom, 20)
                
                // MARK: - 투표 선택지
                Text("*투표 선택지")
                    .foregroundColor(.white)
                    .font(.medium(size: 16))
                
                ZStack(alignment: .center) {
                    Image("vsIcon")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .scaledToFit()
                        .zIndex(1)
                    
                    VStack(spacing: 20) {
                        TextView(placeholder: "A의 선택지를 입력해 주세요", content: $postContent.choiceA, characterLimit: 32)
                            .frame(height: 70)
                        
                        TextView(placeholder: "B의 선택지를 입력해 주세요", content: $postContent.choiceB, characterLimit: 32)
                            .frame(height: 70)
                    }
                }
                .padding(.bottom, 20)
                
                // MARK: - 내용
                Text("내용")
                    .foregroundColor(.white)
                    .font(.medium(size: 16))
                
                TextView(placeholder: "어떤 내용을 추가로 담을까요?", content: $postContent.details, characterLimit: 100)
                    .frame(height: 108)
                    .padding(.bottom, 200)
            }
            .keyboardAdaptive()
            .padding(.top, 24)
            .padding(.horizontal, 24)
        }
        .fillScreen()
    }
    
    init(isPresented: Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        self._isPresented = isPresented
    }
}

extension NewPostView {
    var closeAndRegisterButtons: some View {
        HStack {
            Button(action: {
                if !postContent.isAnyContentEmtpy {
                    showAlert = true
                } else {
                    isPresented = false
                }
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .padding([.top, .bottom, .trailing], 6)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                let postRequest = postContent.toPostRequestInformation()
                sourceObject.register(post: postRequest)
                isPresented = false
            }) {
                Text("등록")
                    .font(.semoBold(size: 18))
                    .foregroundColor(postContent.isAllContentEmpty ? .mono : .naenioPink)
            }
            .disabled(postContent.isAllContentEmpty)
        }
    }
}

fileprivate struct PostContent {
    var title: String = ""
    var choiceA: String = ""
    var choiceB: String = ""
    var details: String = ""
    
    var isAllContentEmpty: Bool {
        title.isEmpty || choiceA.isEmpty || choiceB.isEmpty
    }
    
    var isAnyContentEmtpy: Bool {
        title.isEmpty && choiceA.isEmpty && choiceB.isEmpty && details.isEmpty
    }
    
    func toPostRequestInformation() -> PostRequestInformation {
        let wrappedA = PostRequestInformation.Choice(name: choiceA)
        let wrappedB = PostRequestInformation.Choice(name: choiceA)
        let post = PostRequestInformation(title: title, content: details, categoryID: 0, choices: [wrappedA, wrappedB])
        
        return post
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(isPresented: .constant(true))
    }
}
