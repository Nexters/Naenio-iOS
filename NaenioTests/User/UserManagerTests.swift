//
//  UserTests.swift
//  NaenioTests
//
//  Created by 이영빈 on 2022/08/01.
//

import XCTest
import SwiftUI
@testable import Naenio

class UserManagerTests: XCTestCase {
    let mockUserManager = UserManager(user: mockUser)
    
    func testChangeNickname() throws {
        let expected = "changed"
        mockUserManager.changeNickname(to: expected)
        
        XCTAssertEqual(expected, mockUserManager.user.nickname)
    }
    
    func testChangeProfileImage() throws {
        let expected = Image(systemName: "magnifyingglasses")
        mockUserManager.changeProfileImage(to: expected)
        
        XCTAssertEqual(expected, mockUserManager.user.profileImage)
    }
    
    func testGetPresetProfileImage() throws {
        let expected = ProfileImages().images[1]
        let received = mockUserManager.getPresetProfileImage(index: 1)
        
        XCTAssertEqual(expected, received)
    }
    
    func testIsGetPresetProfileImageSafe() throws {
        let preset = ProfileImages()
        let images = preset.images
        
        let expected = mockUserManager.user.profileImage
        let received = mockUserManager.getPresetProfileImage(index: images.count + 1)
        
        XCTAssertEqual(expected, received)
    }
}
