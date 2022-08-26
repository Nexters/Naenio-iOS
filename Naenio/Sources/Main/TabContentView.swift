//
//  TabContentView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/09.
//

import Foundation
import SwiftUI

struct TabContentView: View {
    @EnvironmentObject var userManager: UserManager
    
    let pageName: TabBarPage.PageType
    
    init(pageName: TabBarPage.PageType = .home) {
        self.pageName = pageName
    }
    
    var body: some View {
        if pageName == .curation {
            CurationView()
        } else if pageName == .home {
            HomeView()
                .environmentObject(userManager)
        } else if pageName == .myPage {
            MyPageView()
                .environmentObject(userManager)
        }
    }
}

