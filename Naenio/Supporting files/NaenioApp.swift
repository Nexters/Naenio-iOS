//
//  NaenioApp.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/09.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct NaenioApp: App {
    @ObservedObject var tokenManager = TokenManager()
    @ObservedObject var userManager = UserManager.shared
    
    @State var isLinkOpened = false
    @State var arrivedPostId: Int = 0 {
        didSet {
            isLinkOpened = true
        }
    }
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: KeyValue.kakaoAPIkey)
        
        if tokenManager.isTokenAvailable, let token = tokenManager.accessToken {
            userManager.updateUserData(with: token)
        }
        
        print(tokenManager.accessToken)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if tokenManager.accessToken == nil {
                    LoginView()
                        .environmentObject(tokenManager)
                        .environmentObject(userManager)
                } else if userManager.user?.nickname == nil,
                          userManager.status == .fetched {
                    OnboardingView()
                        .environmentObject(userManager)
                } else if tokenManager.accessToken != nil,
                          userManager.user != nil,
                          userManager.status == .fetched {
                    MainView()
                        .environmentObject(userManager)
                        .onOpenURL { url in
                            guard let postId = handleUrl(url) else {
                                return
                            }
                            
                            self.arrivedPostId = postId
                        }
                        .background(
                            NavigationLink(destination: OpenedByLinkFullView(postId: arrivedPostId), isActive: $isLinkOpened) {
                                EmptyView()
                            }
                        )
                } else {
                    ZStack(alignment: .center) {
                        Color.background
                            .ignoresSafeArea()
//                        Color.maskGradientVertical
//                            .ignoresSafeArea()
//                            .zIndex(0.1)
//
//                        Color.linearGradientVertical
//                            .ignoresSafeArea()
//                            .zIndex(0)
//
//                        LoadingIndicator()
//                            .zIndex(1)
                    }
                }
            }
        }
    }
    
    // Maybe replaced later by URL handler class
    func handleUrl(_ url: URL) -> Int? {
        print("URL received: \(url)")
        guard let link = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let linkItem = link.queryItems?.filter({ $0.name == "link" }).last?.value,
              let postId = linkItem.components(separatedBy: "//").last
        else {
            return nil
        }
        
        return Int(postId)
    }
}
