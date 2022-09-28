//
//  NoticeDetailView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct NoticeDetailView: View {
    let notice: Notice
    
    var body: some View {
        CustomNavigationView(title: "") {
            ZStack {
                Color.background.ignoresSafeArea()
                
                ScrollView {
                    Rectangle() // placeholder
                        .fill(Color.clear)
                        .frame(height: 8)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(notice.title)
                            .font(.medium(size: 20))
                            .foregroundColor(.white)
                        
                        Text(notice.content)
                            .font(.medium(size: 20))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .fillHorizontal()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
