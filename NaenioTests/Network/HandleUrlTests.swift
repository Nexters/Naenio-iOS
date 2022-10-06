//
//  HandleUrlTests.swift
//  NaenioTests
//
//  Created by 이영빈 on 2022/10/06.
//

import XCTest
@testable import Naenio

final class HandleUrlTests: XCTestCase {
    func testExample() throws {
        let expectation = 50
        let newUrl = URL(string: "https://naenioapp.page.link/?link=https://naenio.shop?postId=\(expectation)&ibi=com.teamVS.Naenio&isi=1634376427&apn=com.nexters.teamversus.naenio")!
        
        var postIdResult = handleUrl(newUrl)
        XCTAssertEqual(expectation, postIdResult)
        
        let originalUrl = URL(string: "https://naenioapp.page.link/?link=https://naenio.app.link?postId=\(expectation)&ibi=com.teamVS.Naenio&isi=1634376427&apn=com.nexters.teamversus.naenio")!
        
        postIdResult = handleUrl(originalUrl)
        XCTAssertEqual(expectation, postIdResult)
    }
}
