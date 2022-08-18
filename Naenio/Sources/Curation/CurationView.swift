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
            VStack(alignment: .leading, spacing: 20) {
                Text("네니오들의 선택")
                    .font(.regular(size: 20))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(themeList) { theme in
                        NavigationLink(destination: HomeView(backgroundColorList: theme.data.backgroundColorList, title: theme.data.title, theme: theme.id, isHomeView: false)) {
                            CurationCardView(theme: theme.data)
                        }
                    }
                }
                .padding(14)
            }
        }
        .fillScreen()
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct CurationView_Previews: PreviewProvider {
    static var previews: some View {
        CurationView()
    }
}
