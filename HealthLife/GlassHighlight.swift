//
//  GlassHighlight.swift
//  HealthLife
//
//  Created by Antonio Almeida on 02/12/25.
//

import SwiftUI

struct GlassHighlight: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.35),
                Color.white.opacity(0.10),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blendMode(.screen)
        .mask(
            Rectangle()
                .padding(.horizontal, 22)
                .padding(.vertical, 18)
        )
        .allowsHitTesting(false)
    }
}
