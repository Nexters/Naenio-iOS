//
//  NewPostView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI

struct NewPostView: View {
    @Binding var isPresented: Bool
    @State var title: String = "placeholder"
    
    var body: some View {
        VStack(alignment: .leading) {
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
                
                Button(action: {}) {
                    Text("등록")
                        .font(.semoBold(size: 18))
                }
            }
            
            Text("*투표 주제")
                .foregroundColor(.white)
            
//            TextEditor(text: $title)
            TextView(text: $title)
                .frame(height: 108)
                .foregroundColor(.white)
                .background(Color.card)
                .cornerRadius(8)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .fillScreen()
        .background(Color.background.ignoresSafeArea())
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(isPresented: .constant(true))
    }
}
