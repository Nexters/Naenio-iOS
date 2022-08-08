//
//  View + Extensions.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

extension View {
    func fillScreen() -> some View {
        return self.modifier(FillScreen())
    }
    
    func fillHorizontal() -> some View {
        return self.modifier(FillHorizontal())
    }
}
