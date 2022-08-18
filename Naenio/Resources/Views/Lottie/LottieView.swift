//
//  LottieView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/17.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    @Binding var isPlaying: Bool
    let animationView: AnimationView

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        if isPlaying {
            animationView.play(completion: { _ in
                self.isPlaying = false
            })
        } else {
            animationView.stop()
        }
    }
    
    init(isPlaying: Binding<Bool>, animation: Lottie.Animation?) {
        let animationView = AnimationView()
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.3
        animationView.translatesAutoresizingMaskIntoConstraints = false

        self._isPlaying = isPlaying
        self.animationView = animationView
    }
}
