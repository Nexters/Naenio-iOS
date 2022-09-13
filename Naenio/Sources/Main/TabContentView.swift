//
//  TabContentView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/09.
//

import SwiftUI
import Introspect

struct TabContentView: View {
    @EnvironmentObject var userManager: UserManager
    
    let pageName: TabBarPage.PageType
    
    init(pageName: TabBarPage.PageType = .home) {
        self.pageName = pageName
    }
    
    var body: some View {
        if pageName == .curation {
            NavigationView {   
                CurationView()
                    .environmentObject(userManager)
                    .navigationBarHidden(true)
                    .navigationBarTitle("")
            }
        } else if pageName == .home {
            NavigationView {
                HomeView()
                    .environmentObject(userManager)
                    .navigationBarHidden(true)
                    .navigationBarTitle("")
            }
        } else if pageName == .myPage {
            MyPageView()
                .environmentObject(userManager)
                .navigationBarHidden(true)
                .navigationBarTitle("")
        }
    }
}
