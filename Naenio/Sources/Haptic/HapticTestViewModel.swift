//
//  HapticViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/07/27.
//

import SwiftUI

class HapticTestViewModel {
    typealias style = UIImpactFeedbackGenerator.FeedbackStyle
    
    let notification = UINotificationFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    var impact: (style) -> UIImpactFeedbackGenerator = { style in
        UIImpactFeedbackGenerator(style: style)
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

