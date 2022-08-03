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
                
                categoryButtons
                
                ScrollView(.vertical) {
                    LazyVStack {
                        CardView()
                    }
                }
            }
            .fillScreen()
            .padding(.horizontal, 20)
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
            
            Button(action: {}) {
                Text("📄 게시한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 15.43,
                                            bgColor: .naenioBlue,
                                            textColor: .white))
            
            Button(action: {}) {
                Text("🗳 참여한 투표")
            }
            .buttonStyle(CapsuleButtonStyle(fontSize: 15.43,
                                            bgColor: .naenioBlue,
                                            textColor: .white))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
