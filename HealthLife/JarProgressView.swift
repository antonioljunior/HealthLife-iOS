//
//  HydrationWaterJarView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 02/12/25.
//
import SwiftUI

// The realistic jar view that uses the JarShape for outline and masks the water fill.
// Now with simple animated surface (no MotionManager).
struct JarProgressView: View {
    var progress: Double // 0...1
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { _ in
            let strokeColor = Color.primary.opacity(0.35)
            let glassFill = Color.primary.opacity(colorScheme == .dark ? 0.06 : 0.04)
            let water = Color.blue

            ZStack(alignment: .bottom) {
                // Glass body (subtle fill)
                JarShape()
                    .fill(glassFill)

                // Water masked to jar interior, animated surface
                WaterFill(
                    progress: progress,
                    color: water
                )
                .mask(JarShape())

                // Glass outline
                JarShape()
                    .stroke(strokeColor, lineWidth: 3)

                // Inner rim highlight for depth
                JarShape()
                    .stroke(Color.white.opacity(0.12), lineWidth: 1.2)
                    .blur(radius: 0.5)

                // Glass highlight overlay
                GlassHighlight()
                    .mask(JarShape())
                    .opacity(0.8)
            }
        }
        .accessibilityElement(children: .ignore)
    }
}
