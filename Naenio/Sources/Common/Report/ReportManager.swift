//
//  ReportManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/30.
//

import Foundation
import RxSwift
import Moya

struct ReportManager {
    static func report(authorId: Int, type: CommentType) -> Single<Response> {
        // !!!: 회원 탈퇴때도 마찬가진데 응답 바디가 비어있으면 RequestService를 쓸 수가 없음
        // 빈 바디 용 서비스를 또 만들거나 이렇게 해야할 듯
        // RequestService의 이름을 바꿀 필요는 있어 보임(무조건 거쳐가야 되는 느낌이라)
        let reportRequest = ReportRequestModel(targetMemberId: authorId, resource: type)
        let sequence = NaenioAPI.postReport(reportRequest).request()
        
        return sequence
    }
}
