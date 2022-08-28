//
//  ReportAndShareSheetView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/17.
//

import SwiftUI

@available(*, deprecated)
struct ReportAndShareSheetView: View {
    @Binding var isPresented: Bool
    
    let postID: Int
    
    var body: some View {
        HStack {
            Button(action: {}) {
                VStack(spacing: 4) {
                    Image("icon_warning")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                    
                    Text("신고하기")
                        .font(.medium(size: 16))
                        .foregroundColor(.warningRed)
                }
                .frame(width: 161, height: 105)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.background)
                )

            }
                
            Spacer()
            
            Button(action: {
                isPresented = false
                ShareManager.share(url: URL(string: "https://naenio.shop/posts/\(postID)"))
            }) {
                VStack(spacing: 8) {
                    Image("icon_share")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                    
                    Text("공유하기")
                        .font(.medium(size: 16))
                        .foregroundColor(.white)
                }
                .frame(width: 161, height: 105)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.background)
                )
            }
        }
    }
}
