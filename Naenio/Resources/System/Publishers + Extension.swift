//
//  KeyboardHeight.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import Combine
import SwiftUI

/// `KeyboardAdaptive`를 위해 사용
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
    
    static var lowSheetNotificationPublisher: AnyPublisher<LowSheetNotification, Never> {
        return NotificationCenter.default.publisher(for: .lowSheetNotification)
            .map { return $0.object as! LowSheetNotification }
            .eraseToAnyPublisher()
    }
    
    static var didVoteHappen: AnyPublisher<Int, Never> {
        return NotificationCenter.default.publisher(for: .didVoteHappen)
            .map { return $0.object as! Int }
            .eraseToAnyPublisher()
    }
}
