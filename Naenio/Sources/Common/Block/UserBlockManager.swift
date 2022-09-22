//
//  UserBlockManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/09/22.
//

import Foundation
import RxSwift
import Moya

struct UserBlockManager {
    static func block(_ memberId: Int) -> Single<Response> {
        // !!!: 응답 바디가 비어있으면 RequestService를 쓸 수가 없음
        let blockRequest = UserBlockRequestModel(targetMemberId: memberId)
        let sequence = NaenioAPI.postBlock(blockRequest).request()
        
        return sequence
    }
}
