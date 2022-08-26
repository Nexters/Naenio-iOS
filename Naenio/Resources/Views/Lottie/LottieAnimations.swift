//
//  LottieView + Enum.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/18.
//

import Foundation
import Lottie

/// 디스크 IO라 비용이 많이 들기 때문에 static하게 만들어 놓고 꺼내 써야 함
class LottieAnimations {
    static let confettiAnimation = Animation.named("confetti")
    static let fullLoading = Animation.named("full_loading")
}
