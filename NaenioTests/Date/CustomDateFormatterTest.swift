//
//  CustomDateFormatterTest.swift
//  NaenioTests
//
//  Created by YoungBin Lee on 2022/08/29.
//

import XCTest
@testable import Naenio

final class CustomDateFormatterTest: XCTestCase {
    func testConvert() throws {
        let originalDateString = "2022-08-28 20:29:53"
        let parsedDate = CustomDateFormatter.convert(from: originalDateString)
        let expected = "2022.08.28"
        
        XCTAssertEqual(parsedDate, expected)
    }
}
