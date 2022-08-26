//
//  Colors.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/07/30.
//

import SwiftUI

extension Color {
    static let naenioBlue = Color("NBlue")
    static let naenioPink = Color("NPink")
    static let background = Color("NBackground")
    static let warningRed = Color("NWarningRed")
    static let naenioGray = Color("NGray")
    static let linearGradStart = Color("NGradStart")
    static let linearGradMiddle = Color("NGradMiddle")
    static let linearGradEnd = Color("NGradEnd")
    
    static let linearGradient = LinearGradient(
        colors: [.linearGradStart, linearGradMiddle, .linearGradEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let angularGradient = AngularGradient(
        gradient: Gradient(colors: [.linearGradStart, .linearGradMiddle, .linearGradEnd, .linearGradStart]),
        center: .center
    )
    
    static let linearGradientVertical = LinearGradient(
        colors: [.linearGradStart, linearGradMiddle, .linearGradEnd],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let maskGradientVertical = LinearGradient(
        colors: [.black.opacity(0), .black.opacity(1), .black.opacity(1)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let mono = Color("mono")
    static let card = Color("NCard")
    static let tabBarBackground = Color("NBottomBackground")
    static let subCard = Color("NCardSub")
}
    
