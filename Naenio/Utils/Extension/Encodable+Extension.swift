//
//  Encodable+Extension.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/17.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(self)
            
            let dictionaryData = try JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any]
            return dictionaryData ?? [ : ]
        } catch { return [ : ] }
    }
}
