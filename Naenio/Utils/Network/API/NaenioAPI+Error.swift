//
//  APIError.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//

import RxSwift
import Moya
import Alamofire
import Then

enum NaenioAPIError: Error {
    case empty
    case requestTimeout(Error)
    case internetConnection(Error)
    case restError(Error, statusCode: Int? = nil, errorCode: String? = nil)
    
    var statusCode: Int? {
        switch self {
        case let .restError(_, statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    
    var errorCodes: [String] {
        switch self {
        case let .restError(_, _, errorCode):
            return [errorCode].compactMap { $0 }
        default:
            return []
        }
    }
    
    var isNetworkError: Bool {
        switch self {
        case let .requestTimeout(error):
            fallthrough
        case let .restError(error, _, _):
            return NaenioAPI.isNotConnection(error: error) || NaenioAPI.isLostConnection(error: error)
        case .internetConnection:
            return true
        default:
            return false
        }
    }
}
