//
//  WaterFill.swift
//  HealthLife
//
//  Created by Antonio Almeida on 02/12/25.
//

import SwiftUI

// Water fill with a subtle looping animation for the surface (no device motion).
struct WaterFill: View {
    let progress: Double // 0...1
    let color: Color

    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width

            // Base water height from progress
            let baseFill = max(0, min(1, progress)) * height

            ZStack(alignment: .bottom) {
                // Base fill from bottom up
                Rectangle()
                    .fill(color.opacity(0.85).gradient)
                    .frame(height: baseFill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

                // Surface cap: a thin rectangle with a gentle waving animation
                Rectangle()
                    .fill(color.opacity(0.95))
                    .frame(height: max(6, height * 0.05))
                    .offset(y: -baseFill + waveOffset(width: width))
                    .blendMode(.plusLighter)
                    .opacity(progress > 0 ? 1 : 0)

                // Soft highlight at the surface
                LinearGradient(
                    colors: [Color.white.opacity(0.22), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 8)
                .offset(y: -baseFill + waveOffset(width: width))
                .opacity(progress > 0 ? 1 : 0)
            }
            .onAppear {
                withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
        }
    }

    private func waveOffset(width: CGFloat) -> CGFloat {
        // Small vertical oscillation to simulate a calm water surface
        let amplitude = max(2, width * 0.01)
        return sin(phase * .pi * 2) * amplitude
    }
}
