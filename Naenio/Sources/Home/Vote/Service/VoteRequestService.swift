//
//  VoteRequestService.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/17.
//
import RxSwift

class VoteRequestService {
    func postVote(with voteRequestModel: VoteRequestModel) -> Single<VoteResponseModel> {
        let sequence = NaenioAPI.postVote(voteRequestModel)
            .request()
            .map { response -> VoteResponseModel in
                let data = response.data
                
                let decoded = try NaenioAPI.jsonDecoder.decode(VoteResponseModel.self, from: data)
                return decoded
            }
        
        return sequence
    }
}
