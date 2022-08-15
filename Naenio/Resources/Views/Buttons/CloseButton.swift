//
//  CloseButton.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/13.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
        }
    }
}
