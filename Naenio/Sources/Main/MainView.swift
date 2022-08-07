//
//  MainView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/31.
//

import SwiftUI

struct MainView: View {
    @State var tabBarPages: [TabBarPage] = [
        TabBarPage(page: CurationView(), selectedIcon: "tab_curation_selected", deselectedIcon: "tab_curation_deselected", tag: 0),
        TabBarPage(page: HomeView(), selectedIcon: "tab_home_selected", deselectedIcon: "tab_home_deselected", tag: 1),
        TabBarPage(page: MyPageView(), selectedIcon: "tab_myPage_selected", deselectedIcon: "tab_myPage_deselected", tag: 2)
    ]
    
    var body: some View {
        TabBarView(pages: $tabBarPages)
            .background(Color.background)
            .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
