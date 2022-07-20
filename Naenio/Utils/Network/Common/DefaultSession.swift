//
//  DefaultSession.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/14.
//

import Foundation
import Moya

class DefaultSession: Session {
    static let sharedSession: DefaultSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Session.default.session.configuration.httpAdditionalHeaders
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 50
        configuration.urlCredentialStorage = nil
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        return DefaultSession(configuration: configuration)
    }()
}
