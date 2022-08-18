//
//  UserManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/01.
//

import SwiftUI

class UserManager: ObservableObject {
    static let shared = UserManager()
    private let localStorageManager: LocalStorageManager
    
    let profileImageIndexKey = LocalStorageKeys.profileIamgeIndex.rawValue
    let nicknameKey = LocalStorageKeys.nickname.rawValue
    let authServiceTypeKey = LocalStorageKeys.authServiceType.rawValue
    @Published private(set) var status: UserStatus = .waiting
    @Published private(set) var user: User?
    
    func updateUserInformation(profileImageIndex: Int = 0, nickname: String = "user", authServiceType: String) {
        status = .fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.user = User(profileImageIndex: profileImageIndex, nickname: nickname, authServiceType: authServiceType)
            self.localStorageManager.save(profileImageIndex, key: self.profileImageIndexKey)
            self.localStorageManager.save(nickname, key: self.nicknameKey)
            self.localStorageManager.save(authServiceType, key: self.authServiceTypeKey)
            self.status = .fetched
        }
    }
    
    // DEBUG: for test
    func DEBUG_AddMockProfile() {
        status = .fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.user = User(profileImageIndex: 0, nickname: "", authServiceType: "APPLE")
            self.status = .fetched
        }
    }
    
    // Methods
    func updateProfileImageIndex(_ index: Int = 0) {
        self.user?.profileImageIndex = index
        localStorageManager.save(index, key: self.profileImageIndexKey)
    }
    
    func updateNickName(_ nickname: String = "user") {
        self.user?.nickname = nickname
        localStorageManager.save(nickname, key: self.nicknameKey)
    }
    
    func updateAuthServiceType(_ authServiceType: String) {
        self.user?.authServiceType = authServiceType
        localStorageManager.save(authServiceType, key: self.authServiceTypeKey)
    }
    
    func getProfileImagesIndex() -> Int {
        if let loadedProfileImageIndex = localStorageManager.load(key: self.profileImageIndexKey),
           let profileImageIndex = loadedProfileImageIndex as? Int {
            return profileImageIndex
        }
        
        return 0
    }
    
    func getNickName() -> String {
        if let loadedNickName = localStorageManager.load(key: self.nicknameKey),
           let nickname = loadedNickName as? String {
            return nickname
        }
        
        return ""
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
    
    func getAuthServiceType() -> String {
        if let loadedAuthServiceType = localStorageManager.load(key: self.authServiceTypeKey),
           let authServiceType = loadedAuthServiceType as? String {
            return authServiceType
        }
        
        return ""
    }
    
    init(_ localStorageManager: LocalStorageManager = LocalStorageManager.shared) {
        self.localStorageManager = localStorageManager
        self.user = User(profileImageIndex: 0, nickname: "", authServiceType: "")
    }
}
