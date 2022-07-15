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
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "15605dc867a5a04c1b606955957b75ce")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    // TODO: Handle errors
                    print("Main view", url)
                    let _ = AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
