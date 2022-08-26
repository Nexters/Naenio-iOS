//
//  User.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/01.
//

import SwiftUI

struct User: Codable {
    let id: Int
    var authServiceType: String
    var profileImageIndex: Int?
    var nickname: String?
}
