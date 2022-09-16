//
//  ProfileChangeViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI
import RxSwift

class ProfileChangeViewModel: ObservableObject {
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    @Published var status: NetworkStatus<Bool> = .waiting
    
    func submitProfileChangeRequest(nickname: String, index: Int) {
        if !nickname.isEmpty {
            self.checkDuplicatedNickname(nickname: nickname, with: index)
        } else {
            // Nickname 바꾸지 않는 케이스 - 인덱스만 포스트
            RequestService<IndexResponseModel>.request(api: .putProfileIndex(index))
                .subscribe(on: serialQueue)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] _ in // Would not use response data
                        guard let self = self else { return }
                        
                        self.status = .done(result: true)
                    }, onFailure: { [weak self] _ in
                        guard let self = self else { return }
                        
                        self.status = .fail(with: ProfileError.networkError)
                    })
                .disposed(by: bag)
        }
    }
    
    private func checkDuplicatedNickname(nickname: String, with index: Int) {
        RequestService<AvailableNicknameResponseModel>.request(api: .getIsNicknameAvailable(nickname))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    let isExist = response.exist
                    
                    print("@@", isExist)
                                        
                    if !isExist {
                        self.postRequestToServer(nickname, index)
                    } else {
                        self.status = .fail(with: ProfileError.duplicatedNickname)
                    }
                }, onFailure: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: ProfileError.networkError)
                })
            .disposed(by: bag)
    }
    
    private func postRequestToServer(_ nickname: String, _ index: Int) {
        let nicknameSequence = RequestService<NicknameResponseModel>.request(api: .putNickname(nickname))
        let profileImageSequence = RequestService<IndexResponseModel>.request(api: .putProfileIndex(index))
        
        Single.zip(nicknameSequence, profileImageSequence)
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _, _ in // Would not use response data
                    guard let self = self else { return }
                    
                    self.status = .done(result: true)
                }, onFailure: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: ProfileError.networkError)
                })
            .disposed(by: bag)
    }
    
    init() {
        print("init")
    }
}

extension ProfileChangeViewModel {
    enum ProfileError: LocalizedError {
        case duplicatedNickname
        case emptyNickname
        case networkError
        
        var errorDescription: String {
            switch self {
            case .duplicatedNickname:
                return "중복된 닉네임입니다"
            case .emptyNickname:
                return "닉네임을 적어주세요"
            case .networkError:
                return "요청을 실행할 수 없습니다. 잠시후 재시도해주세요."
            }
        }
    }
}
