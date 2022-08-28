//
//  VersionView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct VersionView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        CustomNavigationView(title: "버전 정보") {
            ZStack(alignment: .center) {
                Color.background.ignoresSafeArea()
                
                Text("현재 버전: \(appVersion ?? "???")")
                    .font(.engMedium(size: 18))
                    .foregroundColor(.white)
            }
        }
        .navigationBarHidden(true)
    }
}

struct VersionView_Previews: PreviewProvider {
    static var previews: some View {
        VersionView()
    }
}
