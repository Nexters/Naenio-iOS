//
//  VotesViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/06.
//

import SwiftUI

class VotesViewModel: ObservableObject {
    @Published var choices: [Post.Choice]
    
    var isVoted: Bool {
        return choices
            .filter({ $0.isVoted })
            .isEmpty
    }
    
    init(data: [Post.Choice]) {
        self.choices = data
    }
}
