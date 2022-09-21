//
//  Notification + Extension.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import UIKit

// 이 다음에 Publishers + Extension에 가서 publisher로 매핑하세요.

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
    
    /// 안전한 toast alert 이용을 위한 래퍼 함수입니다. 여전히 안전하진 않지만
    func postToastAlertNotification(with notification: ToastInformation) {
        NotificationCenter.default.post(name: .toastAlertNotification, object: notification)
    }
    
    func postToastAlertNotification(_ title: String) {
        NotificationCenter.default.post(name: .toastAlertNotification, object: ToastInformation(title: title))
    }
    
    func postToastAlertWithErrorNotification() {
        NotificationCenter.default.post(name: .toastAlertNotification,
                                        object: ToastInformation(title: "네트워크 에러: 잠시 후 다시 시도해주세요"))
    }
    
    func postNewToastNotification(_ infos: [NewToastInformation]) {
        NotificationCenter.default.post(name: .newToastNotification,
                                        object: ToastContainter(informations: infos))
    }
    
    func postDidVoteHappen(id value: Int) {
        NotificationCenter.default.post(name: .didVoteHappen, object: value)
    }
}

extension Notification.Name {
    static let lowSheetNotification = Notification.Name("lowSheetNotification")
    static let newToastNotification = Notification.Name("newToastNotification")
    static let toastAlertNotification = Notification.Name("toastAlertNotification")
    static let didVoteHappen = Notification.Name("didVoteHappen")
}
