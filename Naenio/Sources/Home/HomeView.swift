//
//  HomeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @Namespace var topID

    var body: some View {
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
                
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        // Placeholder
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 4)
                            .id(topID)
                        
                        LazyVStack(spacing: 20) {
                            ForEach(0..<viewModel.category.rawValue + 5, id: \.self) { _ in
                                CardView()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                                    )
                                    .padding(.horizontal, 20)
                            }
                        }
                        .onChange(of: viewModel.category) { _ in
                            withAnimation(.easeOut(duration: 0.1)) {
                                proxy.scrollTo(topID)
                            }
                        }
                    }
                }
            }
            .fillScreen()
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
