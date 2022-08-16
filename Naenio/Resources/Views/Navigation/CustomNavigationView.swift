//
//  CustomNavigationView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

struct CustomNavigationView<V>: View where V: View {
    let title: String
    let content: V
    
    let trailingButton: CustomNavigationButton?
    let bgColor: Color = .background
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: self.title, button: trailingButton)
                .padding(.vertical, 17)
                .padding(.horizontal, 20)
                .background(self.bgColor.ignoresSafeArea())
            
            content
                .fillScreen()
        }
    }
    
    init(title: String, button: ButtonType = .none, @ViewBuilder _ content: () -> V) {
        self.title = title
        self.content = content()
        
        switch button {
        case .none:
            trailingButton = nil
        case .trailing(title: let title, disabled: let disabled, action: let action):
            self.trailingButton = CustomNavigationButton(title: title, disabled: disabled, action: action)
        }
    }
}

extension CustomNavigationView {
    enum ButtonType {
        case trailing(title: String, disabled: Bool, action: () -> Void)
        case none
    }
}
