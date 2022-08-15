//
//  CustomDivider.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/13.
//

import SwiftUI

struct CustomDivider: View {
    let tintColor = Color(red: 66.0/225, green: 74.0/255, blue: 92.0/255)
    
    var body: some View {
        Rectangle()
            .fill(tintColor)
            .frame(height: 1)
    }
}
