//
//  MainView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/31.
//

import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var userManager: UserManager
    
    @State var selectedTab = 1
    @State fileprivate var tabBarLowSheetInfo = TabBarLowSheetInfo(isPresented: false, title: "", action: {})
    
    @State var pages: [TabBarPage] = [
        TabBarPage(pageName: .curation, selectedIcon: "tab_curation_selected", deselectedIcon: "tab_curation_deselected", tag: 0),
        TabBarPage(pageName: .home, selectedIcon: "tab_home_selected", deselectedIcon: "tab_home_deselected", tag: 1),
        TabBarPage(pageName: .myPage, selectedIcon: "tab_myPage_selected", deselectedIcon: "tab_myPage_deselected", tag: 2)
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(pages) { item in
                TabContentView(pageName: item.pageName)
                    .environmentObject(userManager)
                    .tabItem {
                        Image(self.selectedTab == item.tag ? item.selectedIcon : item.deselectedIcon)
                        Text("") // For padding
                    }
                    .tag(item.tag)
            }
        }
        .introspectTabBarController { controller in
            controller.tabBar.backgroundColor = UIColor(Color.tabBarBackground)
            controller.tabBar.shadowImage = UIImage()
            controller.tabBar.backgroundImage = UIImage()
            
            controller.tabBar.layer.masksToBounds = true
            controller.tabBar.layer.cornerRadius = 14
            controller.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        .onReceive(Publishers.lowSheetNotificationPublisher) { (info: LowSheetNotification) in
            tabBarLowSheetInfo.isPresented = true
            tabBarLowSheetInfo.title = info.title
            tabBarLowSheetInfo.action = info.action
        } // FIXME: 어우 더러워
        .toast(
            isPresented: $tabBarLowSheetInfo.isPresented,
            title: tabBarLowSheetInfo.title,
            action: tabBarLowSheetInfo.action
        )
    }
}

fileprivate struct TabBarLowSheetInfo {
    var isPresented: Bool
    var title: String
    var action: () -> Void
}

struct TabBarPage: Identifiable {
    var id = UUID()
    var pageName: PageType
    var selectedIcon: String
    var deselectedIcon: String
    var tag: Int
    
    enum PageType {
        case curation, home, myPage
    }
}
