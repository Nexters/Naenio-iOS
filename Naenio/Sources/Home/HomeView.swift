//
//  HomeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct HomeView: View {
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
                
                ScrollView(.vertical, showsIndicators: false) {
                    // Placeholder
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 4)
                    
                    LazyVStack(spacing: 20) {
                        ForEach(0..<3) { _ in
                            CardView()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
                                )
                                .padding(.horizontal, 20)
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
            Button(action: {}) {
                Text("전체")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 15.43,
                                            bgColor: .naenioPink,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: {}) {
                Text("📄 게시한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 15.43,
                                            bgColor: .naenioBlue,
                                            textColor: .white))
            .background(
                Capsule()
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
            )
            
            Button(action: {}) {
                Text("🗳 참여한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 15.43,
                                            bgColor: .naenioBlue,
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
