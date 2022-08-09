//
//  HomeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationView { // FIXME: Temporary position
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Feed")
                        .font(.engBold(size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    categoryButtons
                        .padding(.horizontal, 20)
                    
                    // Card scroll view
                    ZStack {
                        if viewModel.status == .loadingDifferentCategoryPosts {
                            loadingIndicator
                                .zIndex(1)
                        }
                        
                        ScrollView(.vertical, showsIndicators: true) {
                            // Placeholder
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 4)
                            
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
                                                if index == viewModel.posts.count - 3 {
                                                    // 무한 스크롤을 위해 끝에서 3번째에서 로딩 -> 개수는 추후 협의
#if DEBUG
                                                    print("Loaded")
#endif
                                                    viewModel.requestMorePosts()
                                                }
                                            }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .onChange(of: viewModel.category) { _ in
                                viewModel.posts.removeAll()
                                viewModel.requestPosts()
                            }
                            
                            // TODO: 디자인 팀이랑 논의
                            // 하단 무한스크롤 중 생기는 버퍼링에 대한 로딩 인디케이터
                            if viewModel.status == .loadingSameCategoryPosts {
                                loadingIndicator
                                    .zIndex(1)
                                    .padding(.vertical, 15)
                            }
                        }
                    }
                    
                }
                .fillScreen()
            }
            .navigationBarHidden(true)
        }
    }
}

extension HomeView {
    var categoryButtons: some View {
        HStack {
            Button(action: { viewModel.category = .entire }) {
                Text("전체")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 16,
                                            bgColor: viewModel.category == .entire ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: { viewModel.category = .wrote }) {
                Text("📄 게시한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 16,
                                            bgColor: viewModel.category == .wrote ? .naenioPink : .naenioBlue ,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: { viewModel.category = .participated }) {
                Text("🗳 참여한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 16,
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
