//
//  NewPostView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/09.
//

import SwiftUI
import Combine
import AlertState

struct NewPostView: View {
    @EnvironmentObject var sourceObject: HomeViewModel
    @Binding var isPresented: Bool
    
    @State fileprivate var postContent = PostContent()
    @AlertState<SystemAlert> var alertState
    
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
                    
                    WrappedTextView(placeholder: "무슨 주제를 담아볼까요?",
                                    content: $postContent.title,
                                    characterLimit: 70,
                                    allowNewline: false)
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
                            WrappedTextView(placeholder: "A의 선택지를 입력해 주세요",
                                            content: $postContent.choiceA,
                                            characterLimit: 32,
                                            allowNewline: false)
                                .frame(height: 70)
                            
                            WrappedTextView(placeholder: "B의 선택지를 입력해 주세요",
                                            content: $postContent.choiceB,
                                            characterLimit: 32,
                                            allowNewline: false)
                                .frame(height: 70)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: - 내용
                    Text("내용")
                        .foregroundColor(.white)
                        .font(.medium(size: 16))
                    
                    WrappedTextView(placeholder: "어떤 내용을 추가로 담을까요?",
                                    content: $postContent.details,
                                    characterLimit: 99,
                                    allowNewline: false)
                        .frame(height: 108)
                    
                    Spacer()
                }
                .moveUpWhenKeyboardAppear(offset: 100)
            }
            .padding(.horizontal, 24)
        }
        .fillScreen()
        .onChange(of: sourceObject.status) { status in
            switch status {
            case .fail(with: let error):
                alertState = .networkErrorHappend(error: error)
            default:
                break
            }
        }
        .showAlert(with: $alertState)
        .animation(nil)
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
                    alertState = .warnBeforeExit(
                        secondaryAction: {
                            UIApplication.shared.endEditing()
                            isPresented = false
                        }) // MARK: Alert
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
                postContent.removeNewlineInContents()
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
    
    var hasNewlineInContents: Bool {
        title.contains("\n") && choiceA.contains("\n") && choiceB.contains("\n") && details.contains("\n")
    }
    
    mutating func removeNewlineInContents() {
        title = removeNewline(title)
        choiceA = removeNewline(choiceA)
        choiceB = removeNewline(choiceB)
        details = removeNewline(details)
    }
    
    private func removeNewline(_ content: String) -> String {
        content.reduce("") { partialResult, character in
            if !character.isNewline {
                return partialResult + String(character)
            } else {
                return partialResult + " "
            }
        }
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
