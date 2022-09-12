//
//  ToastInformation.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/28.
//

import SwiftUI

struct ToastInformation {
    var isPresented: Bool
    var title: String
    var action: () -> Void
    
    init(isPresented: Bool = false, title: String, action: (() -> Void)? = nil) {
        self.isPresented = isPresented
        self.title = title
        self.action = action ?? {}
    }
}
