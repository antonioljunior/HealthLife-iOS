//
//  LoginView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 28/11/25.
//

import SwiftUI

struct LoginBackgroundView: View {
    @State private var move = false
    
    var body: some View {
        ZStack {
            // Círculo 1
            Circle()
                .fill(.yellow.opacity(0.4))
                .frame(width: 350, height: 350)
                .offset(x: move ? -140 : 140, y: move ? -160 : 160)
                .blur(radius: 40)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: move)

            // Círculo 2
            Circle()
                .fill(.red.opacity(0.35))
                .frame(width: 280, height: 280)
                .offset(x: move ? 160 : -160, y: move ? 180 : -180)
                .blur(radius: 40)
                .animation(.easeInOut(duration: 7).repeatForever(autoreverses: true), value: move)
        }
        .onAppear { move.toggle() }
    }
}
