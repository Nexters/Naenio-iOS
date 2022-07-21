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
        KakaoSDK.initSDK(appKey: KeyValue.kakaoAPIkey)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // TODO: Add implementation of further handling later
                    print("URL received: \(url)")
                    guard let link = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
                    print(link.queryItems?.filter{ $0.name == "link" } as Any)
                }
        }
    }
}
