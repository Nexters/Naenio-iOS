//
//  APIError.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//

import RxSwift
import Moya
import Alamofire

extension NaenioAPI {
  func handleInternetConnection<T: Any>(error: Error) throws -> Single<T> {
    guard
      let urlError = Self.convertToURLError(error),
      Self.isNotConnection(error: error)
    else { throw error }
    throw NaenioAPIError.internetConnection(urlError)
  }
    
    func handleTimeOut<T: Any>(error: Error) throws -> Single<T> {
      guard
        let urlError = Self.convertToURLError(error),
        urlError.code == .timedOut
      else { throw error }
      throw NaenioAPIError.requestTimeout(urlError)
    }
  
  func handleREST<T: Any>(error: Error) throws -> Single<T> {
    guard error is NaenioAPIError else {
      throw NaenioAPIError.restError(
        error,
        statusCode: (error as? MoyaError)?.response?.statusCode,
        errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String
      )
    }
    throw error
  }
}

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
