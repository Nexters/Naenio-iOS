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
                
                VStack(spacing: 10) {
                    Image("version_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 108, height: 108)
                        .onTapGesture {
                            HapticManager.shared.notification(type: .warning)
                        }
                    
                    Text("현재 버전")
                        .font(.engMedium(size: 16))
                        .foregroundColor(.white)
                    
                    Text("\(appVersion ?? "?.??.??")")
                        .font(.engMedium(size: 16))
                        .foregroundColor(.mono)
                }
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
