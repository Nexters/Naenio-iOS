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
    @ObservedObject var userManager = UserManager()
    
    @State var isLinkOpened = false
    @State var arrivedLink: Int = 0 {
        didSet {
            isLinkOpened = true
        }
    }
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: KeyValue.kakaoAPIkey)
        
        UITextView.appearance().backgroundColor = .clear
        
        if tokenManager.isTokenAvailable {
            userManager.updateUserInformation(authServiceType: self.userManager.user?.authServiceType ?? "")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if tokenManager.accessToken == nil {
                    LoginView()
                        .environmentObject(tokenManager)
                        .environmentObject(userManager)
                } else if userManager.user == nil,
                          userManager.status == .fetched {
                    OnboardingView()
                        .environmentObject(userManager)
                } else if tokenManager.accessToken != nil,
                          userManager.user != nil,
                          userManager.status == .fetched {
                    MainView()
                        .onOpenURL { url in
                            // TODO: Add implementation of further handling later
                            guard let postId = handleUrl(url) else {
                                return
                            }
                            
                            self.arrivedLink = postId
                        }
                        .background(
                            NavigationLink(destination: Text(String(self.arrivedLink)), isActive: $isLinkOpened) {
                                EmptyView()
                            }
                        )
                } else {
                    ZStack(alignment: .center) {
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
