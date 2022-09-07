//
//  AlertItems.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI
import AlertState

extension SystemAlert {
    func getTitle() -> String {
        switch self {
        case .warnBeforeExit:
            return "정말 나가시겠어요?"
        case .errorHappend:
            return "알 수 없는 에러"
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "회원탈퇴"
        }
    }
    
    func getMessage() -> String? {
        switch self {
        case .warnBeforeExit:
            return "작성 중인 글은 저장되지 않습니다"
        case .errorHappend(let error, _, _):
            return error.localizedDescription
        case .logout:
            return "정말 로그아웃하시겠어요?"
        case .withdrawal:
            return "정말 탈퇴하시겠어요? 탈퇴 후 회원 정보는 다시 복구할 수 없습니다."
        }
    }
    
    func getPrimaryButton() -> AlertButton? {
        switch self {
        case .warnBeforeExit(let primaryAction, _):
            return AlertButton("Cancel", role: .cancel, action: primaryAction ?? {})
        case .errorHappend(_, let primaryAction, _):
            return AlertButton("Cancel", role: .cancel, action: primaryAction ?? {})
        case .logout(let primaryAction, _):
            return AlertButton("닫기", role: .cancel, action: primaryAction ?? {})
        case .withdrawal(let primaryAction, _):
            return AlertButton("닫기", role: .cancel, action: primaryAction ?? {})
        }
    }
    
    func getSecondaryButton() -> AlertButton? {
        switch self {
        case .warnBeforeExit(_, let secondaryAction):
            return AlertButton("OK", action: secondaryAction ?? {})
        case .errorHappend(_, _, let secondaryAction):
            return AlertButton("OK", action: secondaryAction ?? {})
        case .logout(_, let secondaryAction):
            return AlertButton("로그아웃", role: .destructive, action: secondaryAction ?? {})
        case .withdrawal(_, let secondaryAction):
            return AlertButton("회원탈퇴", role: .destructive, action: secondaryAction ?? {})
        }
    }
}
