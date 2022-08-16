//
//  AlertItems.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI

extension AlertType {
    static func getAlert(of type: AlertType, primaryAction: (() -> Void)? = nil, secondaryAction: @escaping () -> Void) -> Alert {
        switch type {
        case .warnBeforeExit:
            return Alert(title: Text("정말 나가시겠어요?"),
                         message: Text("작성 중인 글은 저장되지 않습니다"),
                         primaryButton: .cancel(Text("cancel"), action: primaryAction ?? {}),
                         secondaryButton: .default(Text("Ok"), action: secondaryAction))
        case .errorHappend(let error):
            return Alert(title: Text("알 수 없는 에러"), // FIXME: 어차피 나중에 얼러트 바꿀거라 임시로 아무거나 넣어 놓음
                         message: Text(error.localizedDescription),
                         primaryButton: .cancel(Text("cancel"), action: primaryAction ?? {}),
                         secondaryButton: .default(Text("Ok"), action: secondaryAction))
        case .none:
            return Alert(title: Text("알 수 없는 에러"), // FIXME: 어차피 나중에 얼러트 바꿀거라 임시로 아무거나 넣어 놓음
                         message: Text(""),
                         primaryButton: .cancel(Text("cancel"), action: primaryAction ?? {}),
                         secondaryButton: .default(Text("Ok"), action: secondaryAction))
        }
    }
}
