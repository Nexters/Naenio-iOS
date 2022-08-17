//
//  Notification + Extension.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import UIKit

/// `KeyboardAdaptive`를 위해 사용
extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension NotificationCenter {
    /// 안전한 noti center 이용을 위한 래퍼 함수입니다. 여전히 안전하진 않지만
    func postLowSheetNotification(with notification: LowSheetNotification) {
        NotificationCenter.default.post(name: .lowSheetNotification, object: notification)
    }
}

extension Notification.Name {
    static let lowSheetNotification = Notification.Name("lowSheetNotification")
}
