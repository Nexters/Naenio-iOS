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
    @StateObject var viewModel = HomeViewModel()
    @ObservedObject var scrollViewHelper = ScrollViewHelper()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showNewPost = false
    @State var showComments = false
    var backgroundColorList: [Color]
    var title: String
    var theme: String
    var isHomeView: Bool
    
    init(backgroundColorList: [Color] = [Color.background], title: String = "Feed", theme: String = "", isHomeView: Bool = true) {
        self.backgroundColorList = backgroundColorList
        self.title = title
        self.theme = theme
        self.isHomeView = isHomeView
    }
    
    var body: some View {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(gradient: Gradient(colors: backgroundColorList), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    if scrollViewHelper.scrollDirection == .downward {
                        Text(title)
                            .font(.engBold(size: 24))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                    }
                    
                    if isHomeView {
                        categoryButtons
                            .padding(.horizontal, 20)
                    }
                    
                    // Card scroll view
                    ZStack(alignment: .bottom) {
                        if viewModel.status == .loading(reason: "differentCategoryPosts") {
                            LoadingIndicator()
                                .zIndex(1)
                        }
                        
                        if viewModel.status == .done, viewModel.posts.isEmpty {
                            emptyResultView
                        }
                        
                        ScrollView(.vertical, showsIndicators: true) {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { (index, post) in
                                    NavigationLink(destination: FullView(index: index, post: post).environmentObject(viewModel)) {
                                        CardView(index: index, post: post) {
                                            withAnimation(.spring()) {
                                                showComments = true
                                            }
                                        }
                                        .environmentObject(viewModel)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                                        )
                                        .padding(.horizontal, 20)
                                        .onAppear {
                                            if isHomeView {
                                                if index == viewModel.posts.count - 5 { // FIXME: Possible error
                                                    viewModel.requestMorePosts()
                                                }
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            // 하단 무한스크롤 중 생기는 버퍼링에 대한 로딩 인디케이터
                            if viewModel.status == .loading(reason: "sameCategoryPosts") {
                                LoadingIndicator()
                                    .zIndex(1)
                                    .padding(.vertical, 15)
                            }
                        }
                        .introspectScrollView { scrollView in
                            let control = scrollViewHelper.refreshController
                            if isHomeView {
                                control.addTarget(viewModel, action: #selector(viewModel.requestPosts), for: .valueChanged)
                            } else {
                                viewModel.themeTitle = self.theme
                                control.addTarget(viewModel, action: #selector(viewModel.requestThemePosts), for: .valueChanged)
                            }
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
                .onAppear {
                    if self.isHomeView {
                        self.viewModel.requestPosts()
                    } else {
                        self.viewModel.themeTitle = self.theme
                        self.viewModel.requestThemePosts()
                    }
                }
                
                if isHomeView {
                    floatingButton
                        .padding(20)
                        .ignoresSafeArea(.keyboard)
                }
            }
            .fullScreenCover(isPresented: $showNewPost) {
                NewPostView(isPresented: $showNewPost)
                    .environmentObject(viewModel)
            }
            .customSheet(isPresented: $showComments, height: 650) {
                CommentView(isPresented: $showComments)
            }
            .navigationBarHidden(isHomeView ? true : false)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
        }
}

extension HomeView {
    var categoryButtons: some View {
        HStack {
            Button(action: { viewModel.sortType = nil }) {
                Text("전체")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.sortType == nil ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: { viewModel.sortType = .wrote }) {
                Text("📄 게시한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 14,
                                            bgColor: viewModel.sortType == .wrote ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: { viewModel.sortType = .participated }) {
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
        
    var emptyResultView: some View {
        VStack(spacing: 14) {
            Image("empty")
                .resizable()
                .scaledToFit()
                .frame(width: 59, height: 59)
            
            Text("아직 투표가 없어요!")
                .font(.medium(size: 18))
                .foregroundColor(.naenioGray)
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
    
    var backButton: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .font(.body.weight(.medium))
                .foregroundColor(.white)
                .frame(width: 18, height: 18)
        }
    }
}
    
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
