//
//  AlertType.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI

// !!!: 일단 시스템 기본 alert로 기능 구현만
enum AlertType {
    typealias Action = () -> Void
    
    case warnBeforeExit(primaryAction: Action? = nil, secondaryAction: Action? = nil)
    case errorHappend(error: Error, primaryAction: Action? = nil, secondaryAction: Action? = nil)
    case logout(primaryAction: Action? = nil, secondaryAction: Action? = nil)
    case withdrawal(primaryAction: Action? = nil, secondaryAction: Action? = nil)
    case none
}
