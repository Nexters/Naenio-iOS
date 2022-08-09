//
//  TabContentView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/09.
//

import Foundation
import SwiftUI

struct TabContentView: View {
    let pageName: PageName
    
    init(pageName: PageName = .home) {
        self.pageName = pageName
    }
    
    var body: some View {
        if pageName == .curation {
            CurationView()
        } else if pageName == .home {
            HomeView()
        } else if pageName == .myPage {
            MyPageView()
        }
    }
}

enum PageName {
    case curation, home, myPage
}
