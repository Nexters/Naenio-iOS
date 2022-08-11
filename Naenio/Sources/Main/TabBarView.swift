//
//  TabBarView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/07.
//
import SwiftUI
import Introspect

struct TabBarView: View {
    @State var selectedTab = 1
    @Binding var pages: [TabBarPage]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(pages) { item in
                TabContentView(pageName: item.pageName)
                    .tabItem {
                        Image(self.selectedTab == item.tag ? item.selectedIcon : item.deselectedIcon)
                        Text("") // For padding
                    }
                    .tag(item.tag)
            }
        }
        .introspectTabBarController { contoller in
            contoller.tabBar.barTintColor = UIColor(Color.tabBarBackground)
            contoller.tabBar.isTranslucent = false
            
            contoller.tabBar.layer.masksToBounds = true
            contoller.tabBar.layer.cornerRadius = 14
            contoller.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    init(pages: Binding<[TabBarPage]>) {
        self._pages = pages
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(pages: .constant(
            [TabBarPage(pageName: .curation, selectedIcon: "tab_curation_selected", deselectedIcon: "tab_curation_deselected", tag: 0),
             TabBarPage(pageName: .home, selectedIcon: "tab_home_selected", deselectedIcon: "tab_home_deselected", tag: 1),
             TabBarPage(pageName: .myPage, selectedIcon: "tab_myPage_selected", deselectedIcon: "tab_myPage_deselected", tag: 2)
            ]
        ))
    }
}

struct TabBarPage: Identifiable {
    var id = UUID()
    var pageName: PageName
    var selectedIcon: String
    var deselectedIcon: String
    var tag: Int
}
