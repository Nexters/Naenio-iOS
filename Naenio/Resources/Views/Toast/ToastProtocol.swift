//
//  ToastInformation.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/28.
//

import SwiftUI

// MARK: - Protocols
protocol ToastContainerType {
    associatedtype T: ToastInformationType
    
    var isPresented: Bool { get set }
    var informations: [T] { get set }
}

protocol ToastInformationType {
    var title: String { get }
    var action: () -> Void { get }
}

// MARK: - Structs
struct ToastContainter: ToastContainerType {
    var isPresented: Bool = false
    var informations: [NewToastInformation]
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
