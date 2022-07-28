//
//  HapticTestView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/27.
//

import SwiftUI

struct HapticTestView: View {
    let viewModel = HapticTestViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(Haptic.allCases, id: \.self) { haptic in
                Button(action: {
                    viewModel.generateHaptic(for: haptic)
                }) {
                    Text(haptic.rawValue)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .padding()
                }
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            
        
            NavigationLink(destination: { HapticAdvanvedTestView(viewModel: self.viewModel) }) {
                Text("Go to advanced test view")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
