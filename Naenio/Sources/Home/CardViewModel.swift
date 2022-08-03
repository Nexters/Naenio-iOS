//
//  CardViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
}
