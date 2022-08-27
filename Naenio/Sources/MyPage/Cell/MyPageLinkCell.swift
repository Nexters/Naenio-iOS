//
//  MyPageLinkCell.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct MyPageLinkCell: View {
    let name: String
    let url: URL
    
    var body: some View {
        Button(action: {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }) {
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
    
    
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
