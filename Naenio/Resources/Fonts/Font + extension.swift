//
//  Font + extension.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/07/30.
//

import SwiftUI

extension Font {
    /// Montserrat, weight: 400
    static func engRegular(size: CGFloat = 16) -> Font {
        return Font.custom("Montserrat-Regular", size: size, relativeTo: .body)
    }
    
    /// Montserrat, weight: 500
    static func engMedium(size: CGFloat = 16) -> Font {
        return Font.custom("Montserrat-Medium", size: size, relativeTo: .title2)
    }
    
    /// Montserrat, weight: 600
    static func engSemiBold(size: CGFloat = 16) -> Font {
        return Font.custom("Montserrat-SemiBold", size: size, relativeTo: .title)
    }
    
    /// Montserrat, weight: 700
    static func engBold(size: CGFloat = 16) -> Font {
        return Font.custom("Montserrat-Bold", size: size, relativeTo: .headline)
    }
    
    /// Pretendard, weight: 400
    static func regular(size: CGFloat = 16) -> Font {
        return Font.custom("Pretendard-Regular", size: size, relativeTo: .body)
    }
    
    /// Pretendard, weight: 500
    static func medium(size: CGFloat = 16) -> Font {
        return Font.custom("Pretendard-Medium", size: size, relativeTo: .title2)
    }
    
    /// Pretendard, weight: 600
    static func semoBold(size: CGFloat = 16) -> Font {
        return Font.custom("Montserrat-SemiBold", size: size, relativeTo: .title)
    }
}
