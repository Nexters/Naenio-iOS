//
//  UserManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/01.
//

import SwiftUI

/// - Warning: Thread-safe 하지 않습니다.
///     유저 데이터를 다룰 때는 항상 1개의 작업만 진행되는 것을 보장하세요
class UserManager: ObservableObject {
    // Published vars
    @Published private(set) var user: User?
    @Published private(set) var status: UserStatus = .waiting
    
    // Methods
    func updateProfile() {
        status = .fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.user = nil
            self.status = .fetched
        }
    }
    
    // DEBUG: for test
    func DEBUG_AddMockProfile() {
        status = .fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.user = User(profileImage: Image(""), nickname: "", authServiceType: "")
            self.status = .fetched
        }
    }
    
    func changeNickname(to nickname: String) {
        user?.nickname = nickname
    }
    
    func changeProfileImage(to image: Image) {
        user?.profileImage = image
    }
    
    func changeProfileImageWithPreset(index: Int) {
        user?.profileImage = getPresetProfileImage(index: index)
    }
    
    /// 프리셋에서 이미지를 하나 골라옵니다. 인덱스 에러로부터 안전합니다.
    ///
    ///  (8.16) 이미지 프리셋이 완성됨에 따라 `static`하게 선언된 이미지 프리셋에서
    ///  간접적으로 이미지를 리턴하는 메소드를 생성했습니다. 이에 다음과 같이
    ///  `shared`클래스를 사용하도록 변경되었습니다.
    ///.   `ProfileImages.getImage(of: index)`
    ///
    /// - Parameters:
    ///     - index: 팀 내 협의된 이미지 프리셋의 번호입니다
    func getPresetProfileImage(index: Int) -> Image {
        ProfileImages.getImage(of: index)
    }
}
