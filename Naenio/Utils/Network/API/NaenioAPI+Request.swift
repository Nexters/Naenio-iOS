//
//  NaenioAPI+Request.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/18.
//
import Moya
import RxSwift

extension NaenioAPI {
    static let moyaProvider = MoyaWrapper.provider
  
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
  
    func request(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let endpoint = NaenioAPI.Wrapper(base: self)
        let requestString = "\(endpoint.method) \(endpoint.baseURL) \(endpoint.path)"
        print("endpoint: \(endpoint)")
        return Self.moyaProvider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .catch(self.handleInternetConnection)
            .catch(self.handleTimeOut)
            .catch(self.handleREST)
            .do(
                onSuccess: { response in
                    let requestContent = "🛰 SUCCESS: \(requestString) (\(response.statusCode))"
                    print(requestContent, file, function, line)
                },
                onError: { rawError in
                    switch rawError {
                    case NaenioAPIError.requestTimeout:
                        print("TODO: alert MyAPIError.requestTimeout")
                    case NaenioAPIError.internetConnection:
                        print("TODO: alert MyAPIError.internetConnection")
                    case let NaenioAPIError.restError(error, _, _):
                        print("🛰 FAILURE: \(error)")

                        guard let response = (error as? MoyaError)?.response else { break }
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let errorDictionary = jsonObject as? [String: Any]
                            guard let key = errorDictionary?.first?.key else { return }
                            let message: String
                            if let description = errorDictionary?[key] as? String {
                                message = "🛰 FAILURE: \(requestString) (\(response.statusCode)\n\(key): \(description)"
                            } else if let description = (errorDictionary?[key] as? [String]) {
                                message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(key): \(description)"
                            } else if let rawString = String(data: response.data, encoding: .utf8) {
                                message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            } else {
                                message = "🛰 FAILURE: \(requestString) (\(response.statusCode)"
                            }
                            print(message)
                        }
                    default:
                        print("??")
                    }
                },
                onSubscribe: {
                    let message = "REQUEST: \(requestString)"
                    print(message, file, function, line)
                }
            )
    }
}
