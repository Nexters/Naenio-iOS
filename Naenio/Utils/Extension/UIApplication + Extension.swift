//
//  UIApplication + Extension.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/10.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
