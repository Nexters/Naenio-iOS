//
//  LoadingIndicator.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI
import Lottie

struct LoadingIndicator: View {
    var body: some View {
        LottieView(isPlaying: .constant(true), animation: LottieAnimations.fullLoading, loopMode: .loop)
            .frame(width: 50, height: 50)
    }
}
