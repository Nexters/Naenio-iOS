//
//  ShareManager.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/17.
//

import SwiftUI

struct ShareManager {
    static func share(url: URL?) {
        guard let urlShare = url else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
