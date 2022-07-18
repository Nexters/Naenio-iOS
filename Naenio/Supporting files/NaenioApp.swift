//
//  NaenioApp.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/09.
//

import SwiftUI

@main
struct NaenioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // TODO: Add implementation of further handling later
                    print("URL received: \(url)")
                }
        }
    }
}
