//
//  LoginManager.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/25.
//

import Foundation
import RxSwift

class LoginRequestService {
    func submitUserInformationToServer(with info: LoginRequestInformation) -> Single<UserInformation> {
        let sequence = NaenioAPI.login(info)
            .request()
            .map { response -> UserInformation in
                let data = response.data
                let decoded = try NaenioAPI.jsonDecoder.decode(UserInformation.self, from: data)
                
                return decoded
            }
        
        return sequence
    }
}
