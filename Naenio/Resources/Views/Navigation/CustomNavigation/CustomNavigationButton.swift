//
//  CustomNavigationButton.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

struct CustomNavigationButton: View {
    let title: String
    let disabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            Text(title)
                .font(.semoBold(size: 18))
                .foregroundColor(disabled ? .naenioGray : .naenioPink)
        }
        .disabled(self.disabled)
    }
}
