//
//  Notie.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/09/01.
//

import Foundation

struct Notice: Identifiable, Decodable {
    let id: Int
    let title: String
    let content: String
}
