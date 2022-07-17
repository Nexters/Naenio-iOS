//
//  AuthorizationAPI+Request.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//

import Moya
import RxSwift
import Alamofire
import Then

//Wrapper 정의
extension NaenioAPI {
    struct Wrapper: TargetType  {
        let base: NaenioAPI
        
        var baseURL: URL { self.base.baseURL }
        var path: String { self.base.path }
        var method: Moya.Method { self.base.method }
        var sampleData: Data { self.base.sampleData }
        var task: Task { self.base.task }
        var headers: [String: String]? { self.base.headers }
    }
    
    enum MoyaWrapper {
        struct Plugins {
            var plugins: [PluginType]
            
            init(plugins: [PluginType] = []) {
                self.plugins = plugins
            }
            
            func callAsFunction() -> [PluginType] { self.plugins }
        }
        
        static var provider: MoyaProvider<NaenioAPI.Wrapper> {
            let plugins = Plugins(plugins: [])
            let session = DefaultSession.sharedSession
            
            return MoyaProvider<NaenioAPI.Wrapper>(
                endpointClosure: { target in
                    MoyaProvider.defaultEndpointMapping(for: target)
                },
                session: session,
                plugins: plugins()
            )
        }
    }
}
