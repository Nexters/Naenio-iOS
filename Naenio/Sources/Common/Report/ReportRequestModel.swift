//
//  ReportModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/30.
//

struct ReportRequestModel: Encodable {
    let targetMemberId: Int
    let resource: CommentType
}
