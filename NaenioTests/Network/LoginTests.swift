////
////  NaenioTests.swift
////  NaenioTests
////
////  Created by 이영빈 on 2022/07/09.
////
//
//import XCTest
//import Moya
//@testable import Naenio
//
//class LoginTests: XCTestCase {
//    var provider: MoyaProvider<NaenioAPI>!
//
//    override func setUp() {
//        super.setUp()
//        provider = MoyaProvider<NaenioAPI>(stubClosure: MoyaProvider.immediatelyStub)
//    }
//    
//    func testAppleLogin() throws {
//        let expectation = expectation(description: "request")
//        
//        let expected = UserInformation(token: "mock-server-token")
//        var received: UserInformation?
//        
//        let requestInformation = LoginRequestInformation(authToken: "mock-apple-token", authServiceType: "APPLE")
//        provider.request(NaenioAPI.login(requestInformation)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let data = response.data
//                    received = try NaenioAPI.jsonDecoder.decode(UserInformation.self, from: data)
//                } catch let error {
//                    _ = XCTestError(_nsError: error as NSError)
//                }
//            case .failure(let error):
//                _ = XCTestError(_nsError: error as NSError)
//            }
//            
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5)
//        XCTAssertEqual(received!.token, expected.token)
//    }
//    
//    func testKakaoLogin() throws {
//        let expectation = expectation(description: "request")
//        
//        let expected = UserInformation(token: "mock-server-token")
//        var received: UserInformation?
//        
//        let requestInformation = LoginRequestInformation(authToken: "mock-kakao-token", authServiceType: "APPLE")
//        provider.request(NaenioAPI.login(requestInformation)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let data = response.data
//                    received = try NaenioAPI.jsonDecoder.decode(UserInformation.self, from: data)
//                } catch let error {
//                    _ = XCTestError(_nsError: error as NSError)
//                }
//            case .failure(let error):
//                _ = XCTestError(_nsError: error as NSError)
//            }
//            
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5)
//        XCTAssertEqual(received!.token, expected.token)
//    }
//}
