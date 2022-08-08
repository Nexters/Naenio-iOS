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
    /// - Parameters:
    ///     - index: 팀 내 협의된 이미지 프리셋의 번호입니다
    func getPresetProfileImage(index: Int) -> Image {
        let preset = ProfileImages()
        let images = preset.images
        
        if index < images.count {
            return images[index]
        } else {
            return user?.profileImage ?? Image("")
        }
    }
}
