//
//  MyPageView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/31.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            Text("마이페이지 화면")
                .foregroundColor(.white)
        }
        
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
