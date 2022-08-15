//
//  FeedRequestService.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/13.
//

import RxSwift

class FeedRequestService {
    func getFeed(with feedRequestInformation: FeedRequestInformation) -> Single<FeedResponseModel> {
        let sequence = NaenioAPI.getFeed(feedRequestInformation)
            .request()
            .map { response -> FeedResponseModel in
                let data = response.data
                let decoded = try NaenioAPI.jsonDecoder.decode(FeedResponseModel.self, from: data)
                return decoded
            }
        
        return sequence
    }
}
