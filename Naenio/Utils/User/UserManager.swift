//
//  UserManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/01.
//

import SwiftUI
import RxSwift

/// 프로필과 관련된 정보를 수정합니다
///
/// Get and set`profileImageIndex`, `nickname`,
/// Get `AuthServiceType`
class UserManager: ObservableObject {
    static let shared = UserManager() // FIXME: 흑마법이라 나중에 고쳐야 될 듯..(전역적으로 공유되는 observedobject)
    
    // Dependencies
    private let localStorageManager: LocalStorageManager
    
    // Publihsed vars
    @Published private(set) var status: UserStatus = .waiting
    @Published private(set) var user: User?
    
    // Private vars and lets
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

                    self.user = user
                    self.updateLocalUserData(with: user)
                    print("RX \(user) \(self.getNickName())")
                    self.status = .fetched
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    // MARK: - Updates
    
    /// 로컬 스토리지 한번에 업데이트
    ///
    /// 밖에서 쓸 일이 있을까 싶어서 일단 `private`
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
    
    func updateAuthServiceType(_ type: AuthServiceType) {
        self.user?.authServiceType = type.rawValue
        localStorageManager.save(type.rawValue, key: self.authServiceTypeKey)
    }
    
    // MARK: - Gets
    func getUserId() -> Int {
        if let user = self.user {
            return user.id
        } else {
            return -1
        }
        
//        if let loadedUserId = localStorageManager.load(key: self.idKey),
//           let userId = loadedUserId as? Int {
//            return userId
//        }
//
//        return 0
    }
    
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
    
    init(_ localStorageManager: LocalStorageManager = LocalStorageManager.shared) {
        self.localStorageManager = localStorageManager
    }
}
