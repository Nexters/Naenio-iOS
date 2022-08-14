//
//  CommentView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI
import Introspect

struct CommentView: View {
    @StateObject var viewModel = CommentViewModel()
    @ObservedObject var scrollViewHelper = ScrollViewHelper()
    
    @State var text: String = ""
    @Binding var isPresented: Bool
    @State var isEditing: Bool = false
    
    var body: some View {
            NavigationView {
                ZStack(alignment: .bottom) {
                    Color.card
                        .ignoresSafeArea()
                    
                    //            if viewModel.status == .loading {
                    //                LoadingIndicator()
                    //            }
                    
                    ScrollView {
                        LazyVStack(spacing: 18) {
                            // Sheet's header
                            HStack {
                                CommentCountComponent(count: viewModel.commentsCount ?? 0)
                                
                                Spacer()
                                
                                CloseButton(action: { isPresented = false })
                                    .frame(width: 12, height: 12)
                            }
                            
                            ForEach(viewModel.comments, id: \.id) { comment in
                                CustomDivider()
                                    .frame(width: UIScreen.main.bounds.width)
                                
                                CommentContentView(isPresented: $isPresented, comment: comment, isReply: false)
                            }
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 80)
                        }
                        .padding(.horizontal, 20)
                    }
                    .introspectScrollView { scrollView in
                        scrollView.keyboardDismissMode = .onDrag
                        scrollView.delegate = scrollViewHelper
                    }
                    .onChange(of: scrollViewHelper.currentVerticalPosition) { newValue in
                        NotificationCenter.default.post(name: .scrollOffsetNotification, object: newValue)
                    }
                    .onChange(of: scrollViewHelper.scrollVelocity) { newValue in
                        NotificationCenter.default.post(name: .scrollVelocity, object: newValue)
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Text("😀")
                                .padding(3)
                                .background(Circle().fill(Color.green.opacity(0.2)))
                            
//                            if #available(iOS 16.0, *) {
//                                TextEditor(text: $text)
//                                    .scrollContentBackground(.hidden)
//                                    .background(.subCard)
//                            } else {
//                                TextEditor(text: $text)
//                                    .introspectTextView { textView in
//                                        textView.tintColor = .red
//                                    }
//                            }
                            
//                            TextView(
//                                text: $text,
//                                isEditing: $isEditing,
//                                placeholder: "댓글 추가",
//                                textHorizontalPadding: 14, textVerticalPadding: 7,
//                                placeholderHorizontalPadding: 14, placeholderVerticalPadding: 7,
//                                textColor: .white, placeholderColor: .mono,
//                                isScrollingEnabled: true
//                            )
//                            .background(Color(red: 79.0/255, green: 85.0/255, blue: 100.0/255))
//                            .cornerRadius(3)
                            
                            WrappedTextView(placeholder: "댓글 추가", content: $text, characterLimit: 100, isTight: true)
                            
                            Button(action: {
                                viewModel.registerComment(self.text, parentID: viewModel.parentID)
                                UIApplication.shared.endEditing()
                                text = ""
                            }) {
                                Text("게시")
                                    .font(.semoBold(size: 14))
                                    .foregroundColor(.naenioGray)
                            }
                            .disabled(text.isEmpty)
                            
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .background(Color.background.ignoresSafeArea())
                    }
                    .frame(height: 60)
            }
                .navigationBarHidden(true)

        }
        .redacted(reason: viewModel.status == .loading ? .placeholder : [])
        .onAppear {
            viewModel.requestComments()
        }
    }
}
