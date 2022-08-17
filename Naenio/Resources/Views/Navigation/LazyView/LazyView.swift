//
//  LazyNavigationLink.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/17.
//

import SwiftUI

/// `NavigationLink`의 `destination`을 Lazy하게 로딩하고 싶을 때 사용하는 view입니다.
///
/// LazyView를 사용하지 않으면 눈에 보이는 링크의 목적지가 전부 미리 로딩되어버리는 사태가 발생합니다(네트워크 콜 한번에 30개씩 칠 수도 있음)
struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
