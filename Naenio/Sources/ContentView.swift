//
//  ContentView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/09.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

struct ContentView: View {
    var body: some View {
        LoginTestView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    // TODO: Handle errors
                    let _ = AuthController.handleOpenUrl(url: url)
                }
            })
    }
}
