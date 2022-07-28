//
//  HapticViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/27.
//

// ref:  https://developer.apple.com/documentation/corehaptics/updating_continuous_and_transient_haptic_parameters_in_real_time
import SwiftUI
import CoreHaptics

class HapticTestViewModel {
    typealias style = UIImpactFeedbackGenerator.FeedbackStyle
    
    let engine = try? CHHapticEngine()
    var player: CHHapticPatternPlayer? = nil
    
    let notification = UINotificationFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    var impact: (style) -> UIImpactFeedbackGenerator = { style in
        UIImpactFeedbackGenerator(style: style)
    }
    
    func generateHaptic(intensity: Float, sharpness: Float) {
        // Create an intensity parameter:
        let intensity = CHHapticEventParameter(parameterID:  .hapticIntensity,
                                               value: intensity / 100)
        
        let sharpness = CHHapticEventParameter(parameterID:  .hapticSharpness,
                                               value: sharpness / 100)

        // Create a continuous event with a long duration from the parameters.
        let event = CHHapticEvent(eventType: .hapticContinuous,
                                            parameters: [intensity, sharpness],
                                            relativeTime: 0,
                                            duration: 100)
        
        do {
            // Create a pattern from the continuous haptic event.
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            try startHaptic(with: pattern)
        } catch let error {
            print("Pattern Player Creation Error: \(error)")
        }
    }
    
    private func startHaptic(with pattern: CHHapticPattern) throws {
        if player != nil {
            return
        }
        
        try engine?.start()
        
        player = try engine?.makeAdvancedPlayer(with: pattern)
        try player?.start(atTime: CHHapticTimeImmediate)
    }
    
    func stopHaptic() {
        guard let player = player else {
            return
        }
        
        do {
            try player.stop(atTime: CHHapticTimeImmediate)
            self.player = nil
        } catch let error {
            print("Pattern Player Error: \(error)")
        }
    }
    
    func generateHaptic(for type: Haptic)  {
        switch type {
        case .success:
            notification.notificationOccurred(.success)
        case .warning:
            notification.notificationOccurred(.warning)
        case .error:
            notification.notificationOccurred(.error)
        case .light:
            impact(.light).impactOccurred()
        case .soft:
            impact(.soft).impactOccurred()
        case .medium:
            impact(.medium).impactOccurred()
        case .rigid:
            impact(.rigid).impactOccurred()
        case .heavy:
            impact(.heavy).impactOccurred()
        case .selection:
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                self.selection.selectionChanged()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                timer.invalidate()
            }
        }
    }
}

enum Haptic: String, CaseIterable {
    case success
    case warning
    case error
    case light
    case soft
    case medium
    case rigid
    case heavy
    case selection
}

