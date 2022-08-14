//
//  CommentReplyView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/13.
//

import SwiftUI

struct CommentRepliesView: View {
    typealias Comment = CommentInformation.Comment
    
    @Binding var isPresented: Bool
    @ObservedObject var scrollViewHelper = ScrollViewHelper()
    @ObservedObject var viewModel = CommentRepliesViewModel()
    @State var text: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let comment: Comment
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.card
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 18) {
                    // Sheet's header
                    HStack {
                        Button(action: popNavigation) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Text("답글")
                            .font(.semoBold(size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        CloseButton(action: { self.isPresented = false })
                            .frame(width: 12, height: 12)
                    }
                    
                    CustomDivider()
                    
                    CommentContentView(isPresented: $isPresented, comment: comment, isReply: true)
                    
                    CustomDivider()

                    ForEach(viewModel.replies, id: \.id) { reply in
                        HStack {
                            Text("😀")
                                .padding(3)
                                .opacity(0)
                            
                            CommentContentView(isPresented: $isPresented, comment: comment, isReply: true)
                        }
                    }
                    
                    // placeholder
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 90)
                }
                .padding(.horizontal, 20)
            }
            .onChange(of: scrollViewHelper.currentVerticalPosition) { newValue in
                print(newValue)
                NotificationCenter.default.post(name: .scrollOffsetNotification, object: newValue)
            }
            .onChange(of: scrollViewHelper.scrollVelocity) { newValue in
                NotificationCenter.default.post(name: .scrollVelocity, object: newValue)
            }
            
            // Keyboard
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    Text("😀")
                        .padding(3)
                        .background(Circle().fill(Color.green.opacity(0.2)))
                    
                    WrappedTextView(placeholder: "댓글 추가", content: $text, characterLimit: 200, showLimit: false)
                        .background(Color.card)
                        .cornerRadius(3)
                        .frame(height: 32)
                    
                    Button(action: {}) {
                        Text("게시")
                            .font(.semoBold(size: 14))
                            .foregroundColor(.naenioGray)
                    }
               }
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .background(Color.background.ignoresSafeArea())
            }
        }
        .navigationBarHidden(true)
        .redacted(reason: viewModel.status == .loading ? .placeholder : [])
        .onAppear {
            viewModel.requestComments()
        }
    }
}

extension CommentRepliesView {
    func popNavigation() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
