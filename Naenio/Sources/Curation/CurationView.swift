//
//  CurationView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/31.
//

import SwiftUI

struct CurationView: View {
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    var themeList: [ThemeType] = [ .todayVote, .hallFame, .randomPlay, .goldBalance, .noisy, .collapsedBalance]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 14) {
                Text("네니오들의 선택")
                    .font(.semoBold(size: 20))
                    .foregroundColor(.white)
                    
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(themeList) { theme in
                        NavigationLink(destination: LazyView(HomeView())) {
                            CurationCardView(theme: theme.data)
                        }
                        .frame(width: 165, height: 200)
                    }
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .navigationBarHidden(true)
    }
}

struct CurationView_Previews: PreviewProvider {
    static var previews: some View {
        CurationView()
    }
}
