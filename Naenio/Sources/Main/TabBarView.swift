//
//  TabBarView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/07.
//
import SwiftUI

struct TabBarView: View {
    
    @State var selectedTab = 1
    @Binding var pages: [TabBarPage]
    
    init(pages: Binding<[TabBarPage]>) {
        UITabBar.appearance().isHidden = true
        UITabBar.appearance().layer.cornerRadius = 16
        UITabBar.appearance().layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        UITabBar.appearance().layer.masksToBounds = true
        self._pages = pages
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            TabView(selection: $selectedTab) {
                ForEach(pages) { item in
                    AnyView(_fromValue: item.page)
                        .tabItem {
                            EmptyView()
                        }.tag(item.tag)
                }
            }
            
            HStack { }
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 30,
                  maxHeight: 30,
                  alignment: .bottomLeading
                )
            .background(Color.background)
            
            HStack {
                ForEach(pages) { item in
                    Button(action: {
                        self.selectedTab = item.tag
                    }) {
                        ZStack {
                            Image(self.selectedTab == item.tag ? item.selectedIcon : item.deselectedIcon)
                                .imageScale(.large)
                                .padding(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 30)
            .background(Color.background)
            .cornerRadius(24)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(pages: .constant(
            [TabBarPage(page: CurationView(), selectedIcon: "tab_curation_selected", deselectedIcon: "tab_curation_deselected", tag: 0),
             TabBarPage(page: HomeView(), selectedIcon: "tab_home_selected", deselectedIcon: "tab_home_deselected", tag: 1),
             TabBarPage(page: MyPageView(), selectedIcon: "tab_myPage_selected", deselectedIcon: "tab_myPage_deselected", tag: 2)
            ]
        ))
    }
}

struct TabBarPage: Identifiable {
    var id = UUID()
    var page: Any
    var selectedIcon: String
    var deselectedIcon: String
    var tag: Int
}
