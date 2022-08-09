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
    
    // !!!: DEBUG
    let isDebug = true
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: KeyValue.kakaoAPIkey)
        
        if tokenManager.isTokenAvailable {
            userManager.updateProfile()
        }
        
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            if isDebug {
                HomeView()
                    .onOpenURL { url in
                        handleUrl(url)
                    }
            } else {
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
                    HomeView()
                        .onOpenURL { url in
                            // TODO: Add implementation of further handling later
                            handleUrl(url)
                        }
                } else {
                    ProgressView()
                }
            }
        }
    }
    
    // Maybe replaced later by URL handler class
    func handleUrl(_ url: URL) {
        print("URL received: \(url)")
        guard let link = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        print(link.queryItems?.filter { $0.name == "link" } as Any)
    }
}
