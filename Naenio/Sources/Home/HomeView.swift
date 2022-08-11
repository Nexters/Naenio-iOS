//
//  HomeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI
import Introspect

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @ObservedObject var scrollViewHelper = ScrollViewHelper()

    @State var showNewPost = false
    
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
                ZStack {
                    if viewModel.status == .loadingDifferentCategoryPosts {
                        loadingIndicator
                            .zIndex(1)
                    }
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { (index, post) in
                                NavigationLink(destination: FullView(index: index, post: post).environmentObject(viewModel)) {
                                    CardView(index: index, post: post)
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
                        }
                        
                        // TODO: 디자인 팀이랑 논의
                        // 하단 무한스크롤 중 생기는 버퍼링에 대한 로딩 인디케이터
                        if viewModel.status == .loadingSameCategoryPosts {
                            loadingIndicator
                                .zIndex(1)
                                .padding(.vertical, 15)
                        }
                    }
                    .introspectScrollView { scrollView in
                        let control = scrollViewHelper.refreshController
                        control.addTarget(viewModel, action: #selector(viewModel.requestPosts), for: .valueChanged)
                        control.tintColor = .yellow
                        
                        scrollView.refreshControl = control
                        scrollView.delegate = scrollViewHelper
                    }
                    .onChange(of: viewModel.posts) { _ in
                        scrollViewHelper.refreshController.endRefreshing()
                    }
                    .onChange(of: viewModel.category) { _ in
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

            Button(action: { showNewPost = true }) {
                Image("floatingButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .shadow(radius: 3)
            }
            .padding(20)
        }
        .fullScreenCover(isPresented: $showNewPost) {
            NewPostView(isPresented: $showNewPost)
                .environmentObject(viewModel)
        }
        .navigationBarHidden(true)
    }
}

extension HomeView {
    var categoryButtons: some View {
        HStack {
            Button(action: { viewModel.category = .entire }) {
                Text("전체")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.category == .entire ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: { viewModel.category = .wrote }) {
                Text("📄 게시한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.category == .wrote ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: { viewModel.category = .participated }) {
                Text("🗳 참여한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.category == .participated ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
        }
    }
    
    var loadingIndicator: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
