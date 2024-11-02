//
//  PokeBallProgressView.swift
//  PoKev
//
//  Created by Kevin Kokal on 11/2/24.
//

import SwiftUI

struct PokeBallProgressView: View {
    @State var angle: Double = 0.0
    @State var isAnimating = false
    
    var foreverAnimation: Animation {
        Animation
            .spring(duration: 0.4, bounce: 0)
            .delay(0.2)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Image(.ball)
            .resizable()
            .frame(width: 128, height: 128)
            .rotationEffect(Angle(degrees: isAnimating ? 360.0 : 0.0))
            .animation(self.foreverAnimation, value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}
