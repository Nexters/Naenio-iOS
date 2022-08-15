//
//  RoundedCorner.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/14.
//

import SwiftUI

/// `cornerRadius(_ radius: CGFloat, corners: UIRectCorner)`를 위해 사용
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
