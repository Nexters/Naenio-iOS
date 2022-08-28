//
//  MyPageLinkCell.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct MyPageActionCell: View {
    let name: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            MyPageCell(leading: {
                Text(name)
                    .font(.semoBold(size: 16))
            }, trailing: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            })
        }
    }
    
    init(name: String, action: @escaping () -> Void) {
        self.name = name
        self.action = action
    }
}
