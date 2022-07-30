//
//  TargetType+Extension.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//
/*
 Network Error 처리 시 사용되는 공통 기능 정의 Extension
 - .ECONNABORTED: // Software caused connection abort.
 - URLError.networkConnectionLost // A client or server connection was severed in the middle of an in-progress load.
 */

import Alamofire
import Moya

extension TargetType {
    static func isNotConnected(error: Error) -> Bool {
        Self.convertToURLError(error)?.code == .notConnectedToInternet
    }
    
    static func isLostConnection(error: Error) -> Bool {
        switch error {
        case let AFError.sessionTaskFailed(error: posixError as POSIXError)
            where posixError.code == .ECONNABORTED: // Software caused connection abort.
            break
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            guard urlError.code == URLError.networkConnectionLost else { fallthrough }
        default:
            return false
        }
        return true
    }
    
    static func convertToURLError(_ error: Error) -> URLError? {
        switch error {
        case let MoyaError.underlying(afError as AFError, _):
            fallthrough
        case let afError as AFError:
            return afError.underlyingError as? URLError
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            return urlError
        default:
            return nil
        }
    }
}
