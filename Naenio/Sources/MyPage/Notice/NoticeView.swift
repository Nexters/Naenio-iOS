//
//  NoticeView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct NoticeView: View {
    @ObservedObject var viewModel = NoticeViewModel()
    
    var body: some View {
        CustomNavigationView(title: "공지사항") {
            ZStack {
                Color.background.ignoresSafeArea()
                
                if viewModel.status == .inProgress {
                    LoadingIndicator()
                        .zIndex(1)
                }
                
                if viewModel.notices.isEmpty {
                    EmptyResultView(description: "아직 공지사항이 없어요!")
                } else {
                    ScrollView {
                        Rectangle() // placeholder
                            .fill(Color.clear)
                            .frame(height: 8)
                        
                        VStack(spacing: 11) {
                            ForEach(viewModel.notices, id: \.id) { notice in
                                MyPageNavigationCell(name: notice.title) {
                                    NoticeDetailView(notice: notice)
                                }
                            }
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.getNotices()
            }
        }
        .navigationBarHidden(true)
    }
}
