//
//  CurationDetailView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/18.
//

import SwiftUI

struct CurationDetailView: View {
    let theme: Theme
    var body: some View {
        VStack {
            Text(theme.title)
        }
        .background(
                LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
        )
    }
}

