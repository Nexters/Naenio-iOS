//
//  PostRequestService.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/13.
//

import RxSwift

class PostRequestService {
    func postPost(with postRequest: PostRequestInformation) -> Single<PostResponseModel> {
        let sequence = NaenioAPI.postPost(postRequest)
            .request()
            .map { response -> PostResponseModel in
                let data = response.data
                let decoded = try NaenioAPI.jsonDecoder.decode(PostResponseModel.self, from: data)
                
                
                return decoded
            }
        
        return sequence
    }
}
