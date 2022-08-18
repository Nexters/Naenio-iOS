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
    var name: String
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        if isPlaying {
            animationView.play(completion: { _ in
                self.isPlaying = false
            })
        } else {
            animationView.stop()
        }
    }
}
