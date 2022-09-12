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
    var action: (() -> Void)?
}
