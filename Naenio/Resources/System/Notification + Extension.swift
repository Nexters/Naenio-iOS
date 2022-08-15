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

extension Notification.Name {
    static let scrollOffsetNotification = Notification.Name("scrollOffsetNotification")
    
    static let scrollVelocity = Notification.Name("scrollVelocity")
}
