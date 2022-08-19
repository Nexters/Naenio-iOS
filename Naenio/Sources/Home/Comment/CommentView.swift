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
    let parentId: Int
    
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
                        // placeholder
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 30)
                        
                        // Sheet's header
                        HStack {
                            CommentCountComponent(count: viewModel.commentsCount ?? 0)
                            
                            Spacer()
                            
                            CloseButton(action: { isPresented = false })
                                .frame(width: 12, height: 12)
                        }
                        ForEach(Array(viewModel.comments.enumerated()), id: \.element.id) { (index, comment) in
                            CustomDivider()
                                .frame(width: UIScreen.main.bounds.width)
                            
                            CommentContentCell(isPresented: $isPresented, comment: comment, isReply: false, parentId: parentId)
                        }
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 80)
                    }
                    .padding(.horizontal, 20)
                }
                .introspectScrollView { scrollView in
                    let control = scrollViewHelper.refreshController
                    viewModel.isFirstRequest = true
                    viewModel.postId = self.parentId
                    
                    control.addTarget(viewModel, action: #selector(viewModel.requestcommentAction), for: .valueChanged)
                    control.tintColor = .yellow
                    
                    scrollView.keyboardDismissMode = .onDrag
                    scrollView.refreshControl = control
                    scrollView.delegate = scrollViewHelper
                }
                .onChange(of: viewModel.status) { status in
                    switch status {
                    case .done:
                        scrollViewHelper.refreshController.endRefreshing()
                    case .fail(with: _):
                        scrollViewHelper.refreshController.endRefreshing()
                    default:
                        break
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Text("😀")
                            .padding(3)
                            .background(Circle().fill(Color.green.opacity(0.2)))
                        
                        WrappedTextView(placeholder: "댓글 추가", content: $text, characterLimit: 100, showLimit: false, isTight: true)
                        
                        Button(action: {
                            viewModel.registerComment(self.text, parentID: self.parentId, type: .post)
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
            viewModel.requestComments(postId: parentId, isFirstRequest: true)
        }
    }
}
