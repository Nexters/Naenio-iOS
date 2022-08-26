//
//  CardViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

class CardViewModel: ObservableObject {
    func getImage(of index: Int) -> Image {
        return ProfileImages.getImage(of: index)
    }
}
