//
//  AlertType.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import SwiftUI
import AlertState

enum SystemAlert {
    typealias Action = () -> Void
    
    case warnBeforeExit(primaryAction: Action? = nil, secondaryAction: Action? = nil)
    case errorHappend(error: Error, primaryAction: Action? = nil, secondaryAction: Action? = nil)
    case logout(primaryAction: Action? = nil, secondaryAction: Action? = nil)
    case withdrawal(primaryAction: Action? = nil, secondaryAction: Action? = nil)
}

extension SystemAlert: Identifiable {
    var id: String {
        return title
    }
}

extension SystemAlert: SimpleAlertType {
    var title: String {
        self.getTitle()
    }
    
    var message: String? {
        self.getMessage()
    }
    
    var primaryButton: AlertButton? {
        self.getPrimaryButton()
    }
    
    var secondaryButton: AlertButton? {
        self.getSecondaryButton()
    }
}
