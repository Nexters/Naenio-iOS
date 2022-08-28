//
//  AlertWarpper.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/28.
//

import SwiftUI

@propertyWrapper
struct AlertVariable: DynamicProperty {
    @State var showAlert: Bool = false
    @State var alertType: AlertType = .none
    
    var wrappedValue: AlertType {
        get {
            return alertType
        }
        
        nonmutating set {
            self.alertType = newValue
            showAlert = true
        }
    }
    
    var projectedValue: Binding<Bool> {
        return $showAlert
    }
    
    private func setAlert(to type: AlertType) {
        self.alertType = type
    }
}
