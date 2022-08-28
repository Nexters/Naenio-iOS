//
//  MyPageNavigationCell.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

struct MyPageNavigationCell<Destination>: View where Destination: View {
    let destination: Destination
    let name: String
    
    var body: some View {
        NavigationLink(destination: LazyView(destination)) {
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
        .buttonStyle(PlainButtonStyle())
    }
    
    init(name: String, @ViewBuilder destination: () -> Destination) {
        self.name = name
        self.destination = destination()
    }
}
