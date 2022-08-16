//
//  ProfileChangeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI

class ProfileChangeViewModel: ObservableObject {
    @Published var status: NetworkStatus<UserInformation> = .waiting
    
    func submitUserRequest(_ user: User?) { // TODO: 옵셔널 나중에 고치기
        self.status = .done(result: UserInformation(token: "")) // 임시
    }
}
