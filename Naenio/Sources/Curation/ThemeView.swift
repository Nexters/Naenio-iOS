//
//  HomeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI
import Combine
import Introspect
import AlertState

struct ThemeView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject var viewModel: ThemeViewModel
    @ObservedObject var scrollViewHelper = ScrollViewHelper()
    
    @AlertState<SystemAlert> var alertState
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showComments = false
    @State var selectedPostId: Int?
    private let theme: ThemeType
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: theme.data.backgroundColorList),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                if scrollViewHelper.scrollDirection == .downward {
                    // Nav bar
                    navigationBar
                        .padding(.horizontal, 25)
                        .padding(.bottom, 20)
                }
                
                // Card scroll view
                ZStack(alignment: .center) {
                    if viewModel.status == .loading(.requestPost) {
                        LoadingIndicator()
                            .zIndex(1)
                    }
                    
                    if viewModel.status == .done, viewModel.posts.isEmpty {
                        EmptyResultView(description: "등록된 투표가 없어요!")
                    }
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 20) {
                            ForEach($viewModel.posts) { post in
                                NavigationLink(destination: LazyView(
                                    FullView(post: post)).environmentObject(userManager)
                                ) {
                                    CardView(post: post) {
                                        withAnimation(.spring()) {
                                            showComments = true
                                            selectedPostId = post.wrappedValue.id
                                        }
                                    }
                                    .environmentObject(userManager)
                                    .sheet(isPresented: $showComments) {
                                        CommentView(isPresented: $showComments, parentPost: post, parentPostId: $selectedPostId)
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                                    )
                                    .padding(.horizontal, 20)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // placeholder
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 130)
                        }
                    }
                    .introspectScrollView { scrollView in
                        let control = scrollViewHelper.refreshController
                        control.addTarget(viewModel, action: #selector(viewModel.requestThemePosts), for: .valueChanged)
                        
                        scrollView.keyboardDismissMode = .onDrag
                        scrollView.refreshControl = control
                        scrollView.delegate = scrollViewHelper
                    }
                    .onChange(of: viewModel.status) { status in
                        switch status {
                        case .done:
                            scrollViewHelper.refreshController.endRefreshing()
                        case .fail(with: let error):
                            scrollViewHelper.refreshController.endRefreshing()
                            alertState = .errorHappend(error: error)
                        default:
                            break
                        }
                    }
                }
            }
            .padding(.top, 20)
            .fillScreen()
        }
        .showAlert(with: $alertState)
        .onAppear {
            viewModel.theme = self.theme
            viewModel.requestThemePosts(isPulled: false)
        }
        .navigationBarHidden(true)
    }
    
    init(_ theme: ThemeType) {
        self.theme = theme
        self._viewModel = StateObject(wrappedValue: ThemeViewModel(theme: theme))
    }
}

extension ThemeView {
    var navigationBar: some View {
        ZStack(alignment: .center) {
            HStack {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            
            Text(theme.data.title)
                .font(.engBold(size: 22))
                .foregroundColor(.white)
        }
        .fillHorizontal()
    }
}
