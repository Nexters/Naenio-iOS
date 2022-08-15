//
//  LoadingIndicator.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
    }
}
