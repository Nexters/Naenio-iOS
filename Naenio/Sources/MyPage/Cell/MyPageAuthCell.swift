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
            HStack(spacing: 8) {
                authType.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(authType.rawValue)
                    .font(.semoBold(size: 16))
            }
        })
    }
}

extension MyPageAuthCell {
    enum AuthType: String {
        case apple = "애플"
        case kakao = "카카오"
        
        var image: Image {
            switch self {
            case .apple:
                return Image("btn_login_apple")
            case .kakao:
                return Image("btn_login_kakao")
            }
        }
    }
}

struct MyPageCell_Previews: PreviewProvider {
    static var previews: some View {
        MyPageAuthCell(authType: .kakao)
    }
}
