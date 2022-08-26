//
//  CustomNavigationView + Extension.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import Foundation

extension CustomNavigationView {
    enum ButtonType {
        case trailing(title: String, disabled: Bool, action: () -> Void)
        case none
    }
    
    func hideLeadingButton(_ value: Bool) -> CustomNavigationView {
        if value {
            self.configuration.leadingButton = nil
        }

        return self
    }
    
    func addLeadingButton(title: String, action: @escaping () -> Void) -> CustomNavigationView {
        self.configuration.leadingButton = CustomNavigationBackButton(action: action)
        
        return self
    }
    
    func leadingButtonAction(action: @escaping () -> Void) -> CustomNavigationView {
        self.configuration.leadingButton = CustomNavigationBackButton(action: action)
        
        return self
    }
    
    func addTrailingButton(title: String, disabled: Bool, action: @escaping () -> Void) -> CustomNavigationView {
        self.configuration.trailingButton = CustomNavigationButton(title: title, disabled: disabled, action: action)
        
        return self
    }
}
