//
//  Status.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/16.
//

import Foundation

enum NetworkStatus<T>: Equatable where T: Decodable {
    static func == (lhs: NetworkStatus<T>, rhs: NetworkStatus<T>) -> Bool {
        return lhs.description == rhs.description
    }
    
    case waiting
    case inProgress
    case done(result: T)
    case fail(with: Error)
    
    var description: String {
        switch self {
        case .waiting:
            return "Waiting"
        case .inProgress:
            return "In progres..."
        case .done:
            return "Successfully done"
        case .fail(let error):
            return "Failed with error: \(error.localizedDescription)"
        }
    }
}
