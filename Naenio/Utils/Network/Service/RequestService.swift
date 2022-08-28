//
//  RequestService.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/17.
//
import RxSwift

class RequestService<Response: Decodable> {
    static func request(api: NaenioAPI) -> Single<Response> {
        let sequence = api.request()
            .map { response -> Response in
                let data = response.data
                
                let decoded = try NaenioAPI.jsonDecoder.decode(Response.self, from: data)
                return decoded
            }
        
        return sequence
    }
}
