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
    
    @State fileprivate var postContent = PostContent()
    
    @State var showAlert = false
    @State var alertType: AlertType = .none
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .onTapGesture {
                    // Take focus out of text view when tapped
                    UIApplication.shared.endEditing()
                }
            
            // Header
            VStack(alignment: .leading, spacing: 4) {
                ZStack(alignment: .center) {
                    closeAndRegisterButtons

                    Text("New Post")
                        .font(.engBold(size: 18))
                        .foregroundColor(.white)
                    
                    VStack {
                        Spacer()
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 32)
                .background(Color.background.ignoresSafeArea())
                .zIndex(1)
                
                VStack(alignment: .leading, spacing: 4) {
                    // MARK: - 투표 주제
                    Text("*투표 주제")
                        .foregroundColor(.white)
                        .font(.medium(size: 16))
                    
                    WrappedTextView(placeholder: "무슨 주제를 담아볼까요?", content: $postContent.title, characterLimit: 70)
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
                            WrappedTextView(placeholder: "A의 선택지를 입력해 주세요", content: $postContent.choiceA, characterLimit: 32)
                                .frame(height: 70)
                            
                            WrappedTextView(placeholder: "B의 선택지를 입력해 주세요", content: $postContent.choiceB, characterLimit: 32)
                                .frame(height: 70)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: - 내용
                    Text("내용")
                        .foregroundColor(.white)
                        .font(.medium(size: 16))
                    
                    WrappedTextView(placeholder: "어떤 내용을 추가로 담을까요?", content: $postContent.details, characterLimit: 100)
                        .frame(height: 108)
                    
                    Spacer()
                }
                .moveUpWhenKeyboardAppear(offset: 100)
            }
            .padding(.horizontal, 24)
        }
        .fillScreen()
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .warnBeforeExit:
                return Alert(title: Text("정말 나가시겠어요?"),
                             message: Text("작성 중인 글은 저장되지 않습니다"),
                             primaryButton: .cancel(),
                             secondaryButton: .default(Text("Ok"), action: { isPresented = false }))
            default:
                return Alert(title: Text("알 수 없는 에러"), // FIXME: 어차피 나중에 얼러트 바꿀거라 임시로 아무거나 넣어 놓음
                             message: Text("알 수 없는 에러가 발생했습니다"),
                             primaryButton: .cancel(),
                             secondaryButton: .default(Text("Ok"), action: { isPresented = false }))
            }
        }
    }
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
}

extension NewPostView {
    var closeAndRegisterButtons: some View {
        HStack {
            Button(action: {
                if !postContent.isAnyContentEmtpy {
                    alertType = .warnBeforeExit()
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
                sourceObject.register(postRequest)
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
        let wrappedB = PostRequestInformation.Choice(name: choiceB)
        let post = PostRequestInformation(title: title, content: details, choices: [wrappedA, wrappedB])
        
        return post
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(isPresented: .constant(true))
    }
}
