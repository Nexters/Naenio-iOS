//
//  HomeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI
import Combine
import Introspect

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject var viewModel = HomeViewModel()
    @ObservedObject var scrollViewHelper = ScrollViewHelper()

    @State var showNewPost = false
    @State var showComments = false
    
    @State var selectedPostIndex: Int?
    @State var selectedPostId: Int?
    
    var body: some View {
            ZStack(alignment: .bottomTrailing) {
                Color.background
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    if scrollViewHelper.scrollDirection == .downward {
                        Text("Feed")
                            .font(.engBold(size: 24))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                    }
                    
                    categoryButtons
                        .padding(.horizontal, 20)
                    
                    // Card scroll view
                    ZStack(alignment: .center) {
                        if viewModel.status == .loading(reason: .requestPosts) {
                            LoadingIndicator()
                                .zIndex(1)
                        }
                        
                        if case HomeViewModel.Status.done(_) = viewModel.status, viewModel.posts.isEmpty {
                            EmptyResultView(description: "등록된 투표가 없어요!")
                        }
                        
                        ScrollViewReader { proxy in
                            ScrollView(.vertical, showsIndicators: true) {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 5)
                                    .id("top")
                                
                                LazyVStack(spacing: 20) {
                                    ForEach($viewModel.posts) { index, post in
                                        NavigationLink(destination: LazyView(
                                            FullView(post: post, deletedAction: {
                                                viewModel.delete(at: index)
                                            }).environmentObject(userManager))
                                        ) {
                                            CardView(post: post, action: {
                                                DispatchQueue.main.async {
                                                    self.selectedPostId = post.wrappedValue.id
                                                    self.selectedPostIndex = index
                                                    self.showComments = true
                                                }
                                            }, deletedAction: {
                                                viewModel.delete(at: index)
                                            })
                                            .environmentObject(viewModel)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                                            )
                                            .padding(.horizontal, 20)
                                            .onAppear {
                                                if index == viewModel.posts.count - 5 { // FIXME: Possible error
                                                    // 무한 스크롤을 위해 끝에서 5번째에서 로딩 -> 개수는 추후 협의
        #if DEBUG
                                                    print("Loaded")
        #endif
                                                    viewModel.requestMorePosts()
                                                }
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    // placeholder
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 130)
                                }

                                // 하단 무한스크롤 중 생기는 버퍼링에 대한 로딩 인디케이터
                                // 렉이 생기는 문제가 있어서 일단 가려놓음
//                                if viewModel.status == .loading(reason: .morePosts) {
//                                    LoadingIndicator()
//                                        .zIndex(1)
//                                        .padding(.vertical, 15)
//                                }
                            }
                            .introspectScrollView { scrollView in
                                let control = scrollViewHelper.refreshController
                                control.addTarget(viewModel, action: #selector(viewModel.requestPosts), for: .valueChanged)
                                control.tintColor = .yellow
                                
                                scrollView.keyboardDismissMode = .onDrag
                                scrollView.refreshControl = control
                                scrollView.delegate = scrollViewHelper
                            }
                            .onChange(of: viewModel.status) { status in
                                switch status {
                                case .done(let type):
                                    switch type {
                                    case .register:
                                        withAnimation {
                                            proxy.scrollTo("top")
                                        }
                                    default:
                                        break
                                    }
                                    scrollViewHelper.refreshController.endRefreshing()
                                case .fail(with: _):
                                    scrollViewHelper.refreshController.endRefreshing()
                                default:
                                    break
                                }
                            }
                        }
                        .onChange(of: viewModel.sortType) { _ in
                            viewModel.posts.removeAll()
                            viewModel.requestPosts()
                            DispatchQueue.main.async {
                                withAnimation(.linear(duration: 0.1)) {
                                    scrollViewHelper.scrollDirection = .downward
                                }
                            }
                        }
                    }
                }
                .fillScreen()
                
                floatingButton
                    .padding(20)
            }
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            .fullScreenCover(isPresented: $showNewPost) {
                NewPostView(isPresented: $showNewPost)
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showComments) {
                CommentView(isPresented: $showComments,
                            parentPost: $viewModel.posts[selectedPostIndex ?? 0],
                            parentPostId: $selectedPostId)
                    .environmentObject(userManager)
            }
        }
        
}

extension HomeView {
    var categoryButtons: some View {
        HStack {
            Button(action: {
                viewModel.sortType = nil
                HapticManager.shared.impact(style: .rigid)
            }) {
                Text("전체")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.sortType == nil ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: {
                viewModel.sortType = .wrote
                HapticManager.shared.impact(style: .rigid)
            }) {
                Text("📄 게시한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.sortType == .wrote ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: {
                viewModel.sortType = .participated
                HapticManager.shared.impact(style: .rigid)
            }) {
                Text("🗳 참여한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.sortType == .participated ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
        }
    }
    
    var floatingButton: some View {
        Button(action: { showNewPost = true }) {
            Image("floatingButton")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .shadow(radius: 3)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
