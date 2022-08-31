//
//  DateFormatter.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/29.
//

import Foundation

struct CustomDateFormatter {
    static private let formatter = DateFormatter()
    
    static func convert(from date: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let parsedString = formatter.date(from: date) else {
            return "(알 수 없음)"
        }

        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter.string(from: parsedString)
    }
}
