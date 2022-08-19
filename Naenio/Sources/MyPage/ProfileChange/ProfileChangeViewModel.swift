//
//  ProfileChangeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI

class ProfileChangeViewModel: ObservableObject {
    // Dependencies
    private let userManager: UserManager = UserManager.shared
    
    @Published var status: NetworkStatus<Bool> = .waiting
    
    func submitChangeNicknameRequest(_ nickname: String) { // TODO: 옵셔널 나중에 고치기
        if nickname.isEmpty {
            return
        }
        
        // TODO: 서버 API 붙여야 함!!!
        // if networkingSuccessed {
        userManager.updateNickName(nickname)
        self.status = .done(result: true) // 임시
        // }
        
    }
    
    func submitChangeProfileRequest(_ index: Int) { // TODO: 옵셔널 나중에 고치기
        if index < 0 || index >= ProfileImages.count {
            return
        }
        
        // TODO: 서버 API 붙여야 함!!!
        // if networkingSuccessed {
        userManager.updateProfileImageIndex(index)
        self.status = .done(result: true) // 임시
        // }
        
    }
    
    init() {
        print("init")
    }
    deinit {
        print("deinit")
    }
}
