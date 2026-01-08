//
//  LottieView.swift
//  IbeRickMorty
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    
    init(name: String, loopMode: LottieLoopMode = .loop, animationSpeed: CGFloat = 1.0) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
    }

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
