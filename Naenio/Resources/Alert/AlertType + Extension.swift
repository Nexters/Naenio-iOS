//
//  AlertItems.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI

extension AlertType {
    func getAlert() -> Alert {
        switch self {
        case .warnBeforeExit(let primaryAction, let secondaryAction):
            return Alert(title: Text("정말 나가시겠어요?"),
                         message: Text("작성 중인 글은 저장되지 않습니다"),
                         primaryButton: .cancel(Text("cancel"), action: primaryAction ?? {}),
                         secondaryButton: .default(Text("Ok"), action: secondaryAction))
        case .errorHappend(let error, let primaryAction, let secondaryAction):
            return Alert(title: Text("알 수 없는 에러"),
                         message: Text(error.localizedDescription),
                         primaryButton: .cancel(Text("cancel"), action: primaryAction ?? {}),
                         secondaryButton: .default(Text("Ok"), action: secondaryAction))
        case .logout(let primaryAction, let secondaryAction):
            return Alert(title: Text("로그아웃"),
                         message: Text("정말 로그아웃하시겠어요?"),
                         primaryButton: .destructive(Text("닫기"), action: primaryAction ?? {}),
                         secondaryButton: .default(Text("로그아웃"), action: secondaryAction))
        case .withdrawal(let primaryAction, let secondaryAction):
            return Alert(title: Text("회원탈퇴"),
                         message: Text("정말 탈퇴하시겠어요? 탈퇴 후 회원 정보는 다시 복구할 수 없습니다."),
                         primaryButton: .destructive(Text("닫기"), action: primaryAction ?? {}),
                         secondaryButton: .default(Text("탈퇴하기"), action: secondaryAction))
        case .none:
            return Alert(title: Text("알 수 없는 에러"), // FIXME: 어차피 나중에 얼러트 바꿀거라 임시로 아무거나 넣어 놓음
                         message: Text(""),
                         primaryButton: .cancel(Text("cancel"), action: {}),
                         secondaryButton: .default(Text("Ok"), action: {}))
        }
    }
}
