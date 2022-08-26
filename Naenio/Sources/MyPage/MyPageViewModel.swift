//
//  MyPageViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI
import Combine

class MyPageViewModel: ObservableObject {
    // Dependencies
    private let userManager: UserManager
    private var cancellable: AnyCancellable?

    @Published var user: User?
    
    var profileImage: Image {
        let imageIndex = user?.profileImageIndex ?? 0
        return ProfileImages.getImage(of: imageIndex)
    }
    
    var nickname: String {
        self.user?.nickname ?? "(알 수 없음)"
    }
    
    init(userManager: UserManager = UserManager.shared) {
        self.userManager = userManager
        
        
        let userPublisher = userManager.$user
            .sink { user in
                self.user = user
            }
        
        self.cancellable = userPublisher
    }
}
