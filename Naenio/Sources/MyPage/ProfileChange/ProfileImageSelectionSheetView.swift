//
//  ProfileImageSelectionView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/16.
//

import SwiftUI

struct ProfileImageSelectionSheetView: View {
    // Dependencies
    @Binding var isPresented: Bool
    @Binding var profileImageIndex: Int
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(maximum: 85), spacing: 35), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 35) {
            ForEach((0..<ProfileImages.count), id: \.self) { index in
                ProfileImages.getImage(of: index) // Preset image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85, height: 85)
                    .onTapGesture {
                        profileImageIndex = index
                        HapticManager.shared.impact(style: .light)
                        
                        self.isPresented = false
                    }
            }
        }
        .padding(.bottom, 30)
    }
}
