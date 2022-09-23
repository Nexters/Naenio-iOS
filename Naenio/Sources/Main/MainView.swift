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
    
    @State var toastInformation: ToastInformation = ToastInformation(title: "") // For alert
    @State var toastContainer = ToastContainer(informations: []) // 신고, 삭제, 차단

    @State var pages: [TabBarPage] = [
        TabBarPage(pageName: .curation, selectedIcon: "tab_curation_selected", deselectedIcon: "tab_curation_deselected", tag: 0),
        TabBarPage(pageName: .home, selectedIcon: "tab_home_selected", deselectedIcon: "tab_home_deselected", tag: 1),
        TabBarPage(pageName: .myPage, selectedIcon: "tab_myPage_selected", deselectedIcon: "tab_myPage_deselected", tag: 2)
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(pages) { item in
                TabContentView(pageName: item.pageName)
                    .toastAlert(isPresented: $toastInformation.isPresented, title: toastInformation.title)
                    .environmentObject(userManager)
                    .tabItem {
                        Image(self.selectedTab == item.tag ? item.selectedIcon : item.deselectedIcon)
                        Text("") // For padding
                    }
                    .tag(item.tag)
                    .navigationBarHidden(true)
                    .navigationBarTitle("")
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
        .toast($toastContainer)
        .onReceive(Publishers.newToastAlertNotificationPublisher) { (container: ToastContainer) in
            // 신고, 차단, 삭제
            self.toastContainer = container
            self.toastContainer.isPresented = true
        }
        .onReceive(Publishers.toastAlertNotificationPublisher) { (info: ToastInformation) in
            // Toast alert
            self.toastInformation = info
            self.toastInformation.isPresented = true

            // 2초뒤 숨기기
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.toastInformation.isPresented = false
            }
        }
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
