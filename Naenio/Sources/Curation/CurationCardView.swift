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
        ZStack(alignment: .center) {
            Image(theme.backgroundImageName)
                .resizable()
                .scaledToFit()
                .fillScreen()
                .zIndex(0)
            
            VStack(alignment: .leading, spacing: 14) {
                Text(theme.content)
                    .multilineTextAlignment(.leading)
                    .font(.medium(size: 18))
                    .foregroundColor(.white)
                    .padding(.top, 14)
                
                Spacer()
                
                Text(theme.title)
                    .font(.semoBold(size: 22))
                    .foregroundColor(.white)
                    .padding(.bottom, 24)
            }
            .fillScreen()
            .cornerRadius(20)
            .padding(.horizontal, 20)

        }
    }
}
