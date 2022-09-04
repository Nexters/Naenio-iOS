//
//  MyCommentResponseModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/09/01.
//

import Foundation

// MARK: - Welcome
struct MyCommentResponseModel: Decodable {
    let comments: [MyComment]?
}
