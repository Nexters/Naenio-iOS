//
//  HomeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/04.
//

import Foundation

class HomeViewModel: ObservableObject {
    // Published vars
    @Published var category: Category = .entire // ???: 마지막 선택 저장하는 것도 낫 배드
}

extension HomeViewModel {
    enum Category: Int {
        case entire = 1
        case participated = 2
        case wrote = 3
    }
}
