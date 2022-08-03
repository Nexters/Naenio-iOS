//
//  HomeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/03.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Feed")
                    .font(.engBold(size: 24))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .fillScreen()
            .padding(.horizontal, 20)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
