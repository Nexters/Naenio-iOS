//
//  String+Extension.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/19.
//

import Foundation

extension String {
  var removedEscapeCharacters: String {
    let removedEscapeWithQuotationMark = self.replacingOccurrences(of: "\\\"", with: "")
    let removedEscape = removedEscapeWithQuotationMark.replacingOccurrences(of: "\\", with: "")
    return removedEscape
  }
}
