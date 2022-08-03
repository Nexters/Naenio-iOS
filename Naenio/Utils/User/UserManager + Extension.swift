//
//  UserManager + Extensio .swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import Foundation

extension UserManager {
    enum UserStatus: Equatable {
        static func == (lhs: UserManager.UserStatus, rhs: UserManager.UserStatus) -> Bool {
            return lhs.description == rhs.description
        }
        
        case waiting
        case fetching
        case usable
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .fetching:
                return "Fetching profile..."
            case .usable:
                return "Successfully done"
            case .fail(let error):
                return "Failed with error: \(error.localizedDescription)"
            }
        }
    }
}
