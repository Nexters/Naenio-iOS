//
//  NoticeViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

class NoticeViewModel: ObservableObject {
    @Published var notices: [Notice] = [
        Notice(title: "아이폰 14를 드립니다!", content: "와우와우"),
        Notice(title: "맥북 16인치를 드립니다!", content: "와우와우")
    ]
    
}

// !!!: Temporary model, API가 아직 안 나옴
struct Notice: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}
