//
//  NewPostView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI
import Combine

struct NewPostView: View {
    @EnvironmentObject var sourceObject: HomeViewModel
    @Binding var isPresented: Bool
    
    @State var title: String = ""
    @State var choiceA: String = ""
    @State var choiceB: String = ""
    @State var details: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .scaledToFit()
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("New Post")
                    .font(.engBold(size: 18))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    let postRequest = makePostRequest(title: self.title,
                                                      details: self.details,
                                                      choiceA: self.choiceA,
                                                      choiceB: self.choiceB)
                    sourceObject.register(post: postRequest)
                    isPresented = false
                }) {
                    Text("등록")
                        .font(.semoBold(size: 18))
                        .foregroundColor(title.isEmpty || choiceA.isEmpty || choiceB.isEmpty ? .mono : .naenioPink)
                }
                .disabled(title.isEmpty || choiceA.isEmpty || choiceB.isEmpty)
            }
            .padding(.bottom, 32)
            
            // MARK: - 투표 주제
            Text("*투표 주제")
                .foregroundColor(.white)
                .font(.medium(size: 16))
            
            TextView(placeholder: "무슨 주제를 담아볼까요?", content: $title, characterLimit: 72)
                .frame(height: 108)
                .padding(.bottom, 20)
            
            // MARK: -  투표 선택지
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
                    TextView(placeholder: "A의 선택지를 입력해 주세요", content: $choiceA, characterLimit: 32)
                        .frame(height: 70)
                    
                    TextView(placeholder: "B의 선택지를 입력해 주세요", content: $choiceB, characterLimit: 32)
                        .frame(height: 70)
                }
            }
            .padding(.bottom, 20)

            // MARK: -  내용
            Text("내용")
                .foregroundColor(.white)
                .font(.medium(size: 16))
            
            TextView(placeholder: "어떤 내용을 추가로 담을까요?", content: $details, characterLimit: 100)
                .frame(height: 108)

            Spacer()
        }
        .onTapGesture {
            // Take focus out of text view when tapped
            UIApplication.shared.endEditing()
        }
        .padding(.horizontal, 24)
        .fillScreen()
        .background(Color.background.ignoresSafeArea())
    }
    
    func makePostRequest(title: String, details: String, choiceA: String, choiceB: String) -> PostRequest {
        let wrappedA = PostRequest.Choice(name: choiceA)
        let wrappedB = PostRequest.Choice(name: choiceA)
        let post = PostRequest(title: title, content: details, categoryID: 0, choices: [wrappedA, wrappedB])
        
        return post
    }
    
    init(isPresented: Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        self._isPresented = isPresented
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(isPresented: .constant(true))
    }
}
