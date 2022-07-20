//
//  HttpResponseCode.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//
/*
 service manager layer status
 */
import Foundation

enum HttpResponseCode: Int {
    case getSuccess = 200
    case noContent = 204
    
    case badRequest = 400
    case tokenExpired = 401
    case accessDenied = 403
    
    case serverErr = 500
}
