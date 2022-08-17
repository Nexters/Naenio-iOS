//
//  TabBarView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/07.
//
import SwiftUI
import Introspect
import Combine

struct TabBarView: View {
    @State var selectedTab = 1
    @State var tabBarLowSheetInfo = TabBarLowSheetInfo(isPresented: false, postId: 0)
    
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
        .introspectTabBarController { controller in
            controller.tabBar.isTranslucent = false
            controller.tabBar.layer.masksToBounds = true
            controller.tabBar.layer.cornerRadius = 14
            controller.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        .onReceive(Publishers.lowSheetNotificationPublisher) { (value: LowSheetNotification) in
            tabBarLowSheetInfo.isPresented = true
            tabBarLowSheetInfo.postId = value.postId
        }
        .lowSheet(isPresented: $tabBarLowSheetInfo.isPresented) {
            ReportAndShareSheetView(
                isPresented: $tabBarLowSheetInfo.isPresented,
                postID: tabBarLowSheetInfo.postId
            )
                .padding(.horizontal, 27)
        }
    }
    
    init(pages: Binding<[TabBarPage]>) {
        self._pages = pages
        
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Color.tabBarBackground)
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

extension TabBarView {
    struct TabBarLowSheetInfo {
        var isPresented: Bool
        var postId: Int
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
