//
//  NetworkResponseHandlingTests.swift
//  NaenioTests
//
//  Created by Young Bin on 2022/09/24.
//

import XCTest
import Moya
import Foundation
import RxSwift

@testable import Naenio

final class NetworkResponseHandlingTests: XCTestCase {
    let bag = DisposeBag()
    
    func getErrorProvider(giving statusCode: Int) -> MoyaProvider<NaenioAPI> {
        let endpointClosure = { (target: NaenioAPI) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(statusCode, Data()) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }

        let stubbingProvider = MoyaProvider<NaenioAPI>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        
        return stubbingProvider
    }

    func test_handlingResponse_400() throws {
        let provider = getErrorProvider(giving: 400)
        let expectation = expectation(description: "request")
        
        NaenioAPI.deleteAccount.request(provider: provider)
            .subscribe(
                onSuccess: { response in
                    XCTFail("Wrong status code is not handled properly: \(response.statusCode)")
                },
                onFailure: { error in
                    print(error)
                    _ = XCTestError(_nsError: error as NSError)
                },
                onDisposed: {
                    expectation.fulfill()
                }
            )
            .disposed(by: bag)
            
        
        waitForExpectations(timeout: 5)
//        XCTAssertEqual(received!.token, expected.token)
    }
}
