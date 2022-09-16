//
//  DevelopersView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/27.
//

import SwiftUI

struct DevelopersInfoView: View {
    
    var body: some View {
        CustomNavigationView(title: "개발자 정보") {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 26) {
                    Description(division: "Designer", names: ["박주리", "곽민주"])
                    Description(division: "iOS Developers", names: ["이영빈", "조윤영"])
                    
                    Description(division: "Android Developers", names: ["오해성", "김유나"])
                    
                    Group {
                        Description(division: "Backend Developers", names: ["김경준"])
                        Description(division: "Frontend Developers", names: ["김경준"])
                    }
                    
                    Spacer()
                }
                .fillHorizontal()
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .navigationBarHidden(true)
    }
}

extension DevelopersInfoView {
    private struct Description: View {
        @State var kimEasterEggCount = 5

        let division: String
        let names: [String]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(division)
                    .font(.engMedium(size: 16))
                    .foregroundColor(.mono)
                
                HStack(spacing: 0) {
                    ForEach(names, id: \.self) { name in
                        Text(name)
                            .onTapGesture {
                                if name == "조윤영" {
                                    let url = URL(string: "https://choyoonyoung98.github.io/")!
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url)
                                    }
                                } else if name == "이영빈" {
                                    let url = URL(string: "https://enebin.medium.com")!
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url)
                                    }
                                } else if name == "김경준" {
                                    HapticManager.shared.impact(style: .light)
                                    
                                    if kimEasterEggCount <= 0 {
                                        let kimsURL = URL(string: "https://www.linkedin.com/in/kouz/?originalSubdomain=kr")!
                                        if UIApplication.shared.canOpenURL(kimsURL) {
                                            UIApplication.shared.open(kimsURL)
                                        }
                                    } else {
                                        kimEasterEggCount -= 1
                                    }
                                }
                            }
                        
                        if names.last != name {
                            Text(", ")
                        }
                    }
                }
                .foregroundColor(.white)
            }
        }
    }
}
