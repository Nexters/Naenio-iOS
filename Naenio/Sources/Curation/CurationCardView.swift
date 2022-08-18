//
//  CurationCardView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/17.
//

import SwiftUI

struct CurationCardView: View {
    let theme: Theme
    @State var showNewPost = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 14) {
                Text(theme.content)
                    .multilineTextAlignment(.leading)
                    .font(.regular(size: 18))
                    .foregroundColor(.white)
                    .padding(.top, 14)
                Spacer()
                
                Text(theme.title)
                    .font(.regular(size: 22))
                    .foregroundColor(.white)
                    .padding(.bottom, 24)
            }
            .cornerRadius(20)
            .fullBackground(imageName: theme.backgroundImage)
        }
        .frame(width: UIScreen.main.bounds.width / 2.35, height: UIScreen.main.bounds.width / 2.35 * 1.2)
    }
}
