//
//  ToastInformation.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/28.
//

import SwiftUI

protocol ToastContainerType {
    var isPresented: Bool { get set }
    var informations: [ToastInformationType] { get }
}

protocol ToastInformationType {
    var title: String { get }
    var action: () -> Void { get }
}

struct ToastContainter: ToastContainerType {
    var isPresented: Bool
    var informations: [ToastInformationType]
}

struct NewToastInformation: ToastInformationType {
    var title: String
    var action: () -> Void
}

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
