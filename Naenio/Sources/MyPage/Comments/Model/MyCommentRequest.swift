//
//  MyCommentRequest.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/09/01.
//

import Foundation

struct MyCommentRequest: Encodable {
    let size: Int
    let lastCommentId: Int?
}
