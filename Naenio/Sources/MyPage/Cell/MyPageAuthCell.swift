//
//  MyPageCell.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI

struct MyPageAuthCell: View {
    let authType: AuthType
    
    var body: some View {
        MyPageCell(leading: {
            Text("🔒 소셜 로그인 정보")
                .font(.semoBold(size: 16))
        }, trailing: {
            Text(authType.rawValue)
                .font(.semoBold(size: 16))
        })
    }
}

extension MyPageAuthCell {
    enum AuthType: String {
        case apple = "애플"
        case kakao = "카카오"
    }
}

struct MyPageCell_Previews: PreviewProvider {
    static var previews: some View {
        MyPageAuthCell(authType: .kakao)
    }
}
