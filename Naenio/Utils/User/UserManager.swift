//
//  UserManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/01.
//

import SwiftUI
import RxSwift

class UserManager: ObservableObject {
    static let shared = UserManager()
    private let localStorageManager: LocalStorageManager
    
    @Published private(set) var status: UserStatus = .waiting
    @Published private(set) var user: User?
    
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    // Local stroage keys
    private let idKey = LocalStorageKeys.id.rawValue
    private let profileImageIndexKey = LocalStorageKeys.profileIamgeIndex.rawValue
    private let nicknameKey = LocalStorageKeys.nickname.rawValue
    private let authServiceTypeKey = LocalStorageKeys.authServiceType.rawValue
    
    /// 서버 데이터를 받아 옴
    func updateUserData(with token: String) {
        status = .fetching
        
        // 여기가 API 업데이트여야 하는데 로컬 업데이트 였음
        RequestService<User>.request(api: .getUser(token))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] user in
                    guard let self = self else { return }
                    print("RX \(user)")

                    self.user = user
                    self.updateLocalUserData(with: user)

                    print("RX \(user)")

                    self.status = .fetched
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    // MARK: - Updates
    
    /// 로컬 스토리지 업데이트
    private func updateLocalUserData(with user: User) {
        self.localStorageManager.save(user.id, key: self.idKey)
        self.localStorageManager.save(user.profileImageIndex, key: self.profileImageIndexKey)
        self.localStorageManager.save(user.nickname, key: self.nicknameKey)
        self.localStorageManager.save(user.authServiceType, key: self.authServiceTypeKey)
    }
    
    func updateProfileImageIndex(_ index: Int) {
        self.user?.profileImageIndex = index
        localStorageManager.save(index, key: self.profileImageIndexKey)
    }
    
    func updateNickName(_ nickname: String) {
        self.user?.nickname = nickname
        localStorageManager.save(nickname, key: self.nicknameKey)
    }
    
    func updateAuth(_ type: AuthServiceType) {
        self.user?.authServiceType = type.rawValue
        localStorageManager.save(type.rawValue, key: self.authServiceTypeKey)
    }
    
    // MARK: - Gets
    func getProfileImagesIndex() -> Int {
        if let loadedProfileImageIndex = localStorageManager.load(key: self.profileImageIndexKey),
           let profileImageIndex = loadedProfileImageIndex as? Int {
            return profileImageIndex
        } else {
            return 0
        }
    }
    
    func getNickName() -> String {
        if let loadedNickName = localStorageManager.load(key: self.nicknameKey),
           let nickname = loadedNickName as? String {
            return nickname
        } else {
            return "(알 수 없음)"
        }
    }
    
    func getAuthServiceType() -> String {
        if let loadedAuthServiceType = localStorageManager.load(key: self.authServiceTypeKey),
           let authServiceType = loadedAuthServiceType as? String {
            return authServiceType
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
    
    init(_ localStorageManager: LocalStorageManager = LocalStorageManager.shared) {
        self.localStorageManager = localStorageManager
    }
}
