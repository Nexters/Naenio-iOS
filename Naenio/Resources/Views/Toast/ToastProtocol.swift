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
struct ToastContainer: ToastContainerType {
    var isPresented: Bool = false
    var informations: [NewToastInformation]
}

struct NewToastInformation: ToastInformationType {
    var title: String
    var action: () -> Void
}

extension NewToastInformation {
    typealias Action = () -> Void
    
    static func deleteTemplate(_ action: @escaping Action) -> [Self] {
        return [NewToastInformation(title: "삭제하기", action: action)]
    }
    
    static func blockAndReportTemplate(blockAction: @escaping Action,
                                       reportAction: @escaping Action) -> [Self] {
        return [
            NewToastInformation(title: "사용자 차단하기", action: blockAction),
            NewToastInformation(title: "피드 신고하기", action: reportAction)
        ]
    }
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
