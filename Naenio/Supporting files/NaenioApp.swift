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

    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: KeyValue.kakaoAPIkey)
    }
    
    var body: some Scene {
        WindowGroup {
            if tokenManager.accessToken == nil {
                LoginView()
                    .environmentObject(tokenManager)
            } else if userManager.user == nil {
                // OnboardingView()
            } else {
                // MainView()
//                    .onOpenURL { url in
//                        // TODO: Add implementation of further handling later
//                        print("URL received: \(url)")
//                        guard let link = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
//                        print(link.queryItems?.filter { $0.name == "link" } as Any)
//                    }
            }
        }
        
    }
}
