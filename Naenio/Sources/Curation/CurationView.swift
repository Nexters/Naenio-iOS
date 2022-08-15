//
//  CurationView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/31.
//

import SwiftUI

struct CurationView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            Text("큐레이션 화면")
                .foregroundColor(.white)
        }
        
    }
}

struct CurationView_Previews: PreviewProvider {
    static var previews: some View {
        CurationView()
    }
}
