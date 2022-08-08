//
//  UserError.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/01.
//

import Foundation

enum UserError: LocalizedError {
case invalidProfileImageIndex
    
    var errorDescription: String? {
        switch self {
        case .invalidProfileImageIndex:
            return "Profile image index is invalid."
        }
    }
}
