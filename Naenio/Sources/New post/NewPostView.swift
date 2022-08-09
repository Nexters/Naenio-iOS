//
//  NewPostView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI
import Combine

struct NewPostView: View {
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
                
                Button(action: { isPresented = false }) {
                    Text("등록")
                        .font(.semoBold(size: 18))
                        .foregroundColor(title.isEmpty || choiceA.isEmpty || choiceB.isEmpty ? .mono : .naenioPink)
                }
                .disabled(title.isEmpty || choiceA.isEmpty || choiceB.isEmpty)
            }
            .padding(.bottom, 32)
            
            // 투표 주제
            Text("*투표 주제")
                .foregroundColor(.white)
                .font(.medium(size: 16))
            
            TextView(placeholder: "무슨 주제를 담아볼까요?", content: $title, characterLimit: 72)
                .frame(height: 108)
                .padding(.bottom, 20)
            
            // 투표 선택지
            Text("*투표 선택지")
                .foregroundColor(.white)
                .font(.medium(size: 16))
            
            TextView(placeholder: "A의 선택지를 입력해 주세요", content: $choiceA, characterLimit: 32)
                .frame(height: 70)
                .padding(.bottom, 16)
            
            TextView(placeholder: "B의 선택지를 입력해 주세요", content: $choiceB, characterLimit: 32)
                .frame(height: 70)
                .padding(.bottom, 20)

            // 내용
            Text("내용")
                .foregroundColor(.white)
                .font(.medium(size: 16))
            
            TextView(placeholder: "어떤 내용을 추가로 담을까요?", content: $details, characterLimit: 100)
                .frame(height: 108)

            Spacer()
        }
        .padding(.horizontal, 24)
        .fillScreen()
        .background(Color.background.ignoresSafeArea())
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
