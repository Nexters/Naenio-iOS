//
//  AuthorizationAPI+Request.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//

import Moya
import RxSwift
import Alamofire
import Foundation

// Wrapper 정의
extension NaenioAPI {
    enum MoyaWrapper {
        struct Plugins {
            var plugins: [PluginType]
            
            init(plugins: [PluginType] = []) {
                self.plugins = plugins
            }
            
            func callAsFunction() -> [PluginType] { self.plugins }
        }
        
        static var provider: MoyaProvider<NaenioAPI> {
            let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
            let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
            
            let plugins = Plugins(plugins: [
                networkLogger
            ])
            let session = DefaultSession.sharedSession
            
            return MoyaProvider<NaenioAPI>(
                endpointClosure: { target in
                    MoyaProvider.defaultEndpointMapping(for: target)
                },
                session: session,
                plugins: plugins()
            )
        }
    }
}
