//
//  ProfileImages.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/16.
//

import SwiftUI

class ProfileImages {
    static let shared = ProfileImages()
    
    private let images: [Image] = [
        Image("profile_dog1"),
        Image("profile_dog2"),
        Image("profile_dog3"),
        Image("profile_cat1"),
        Image("profile_cat2"),
        Image("profile_cat3"),
        Image("profile_rabbit1"),
        Image("profile_rabbit2"),
        Image("profile_rabbit3")
    ]
    
    static var count: Int {
        return self.shared.images.count
    }
    
    static func getImage(of index: Int) -> Image {
        let preset = self.shared.images
        
        if index < preset.count {
            return preset[index]
        } else {
            return Image(systemName: "xmark") // !!!: 오류 플레이스 홀더 변경
        }
    }
}
