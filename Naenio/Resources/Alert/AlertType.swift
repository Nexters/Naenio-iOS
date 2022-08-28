//
//  AlertType.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI

// !!!: 일단 시스템 기본 alert로 기능 구현만
enum AlertType {
    case warnBeforeExit
    case errorHappend(error: Error)
    case logout
    case none
}
