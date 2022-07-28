//
//  HapticAdvanvedTestView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/28.
//

import SwiftUI

struct HapticAdvanvedTestView: View {
    @State var intensity: Float = 50
    @State var sharpness: Float = 50

    var viewModel: HapticTestViewModel
    
    var body: some View {
        VStack() {
            Text("새 값으로 테스트하려면 stop하고 start해야 함")
                .padding(.bottom, 30)
            
            Slider(value: $intensity, in: 0...100, step: 1)
            Text("Intensity: \(Int(intensity))")
            
            Slider(value: $sharpness, in: 0...100, step: 1)
            Text("Sharpness: \(Int(sharpness))")
                .padding(.bottom, 20)
            
            HStack(spacing: 30) {
                Button(action: {
                    viewModel.generateHaptic(intensity: self.intensity, sharpness: self.sharpness)
                }) {
                    Text("Start")
                }
                
                Button(action: {
                    viewModel.stopHaptic()
                }) {
                    Text("Stop")
                }
            }
        }
        .padding()
        
    }
}
