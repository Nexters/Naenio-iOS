//
//  FillScreen.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct FillHorizontal: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading
            )
    }
}
