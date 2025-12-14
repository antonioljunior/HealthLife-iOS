//
//  JarShape.swift
//  HealthLife
//
//  Created by Antonio Almeida on 02/12/25.
//
import SwiftUI

struct JarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        let neckWidth = w * 0.36
        let neckHeight = h * 0.20
        let shoulderWidth = w * 0.78
        let shoulderHeight = h * 0.10
        let bodyTopY = neckHeight + shoulderHeight
        let bodyBottomY = h * 0.92
        let bodyCorner: CGFloat = w * 0.03

        var p = Path()
        p.move(to: CGPoint(x: (w + neckWidth) / 2, y: 0))
        p.addLine(to: CGPoint(x: (w - neckWidth) / 2, y: 0))
        p.addLine(to: CGPoint(x: (w - neckWidth) / 2, y: neckHeight * 0.65))
        p.addQuadCurve(
            to: CGPoint(x: (w - shoulderWidth) / 2, y: bodyTopY),
            control: CGPoint(x: (w - neckWidth) / 2 - w * 0.06, y: neckHeight + shoulderHeight * 0.3)
        )
        p.addLine(to: CGPoint(x: (w - shoulderWidth) / 2, y: bodyBottomY - bodyCorner))
        p.addQuadCurve(
            to: CGPoint(x: (w + shoulderWidth) / 2, y: bodyBottomY - bodyCorner),
            control: CGPoint(x: w / 2, y: bodyBottomY + bodyCorner * 0.9)
        )
        p.addLine(to: CGPoint(x: (w + shoulderWidth) / 2, y: bodyTopY))
        p.addQuadCurve(
            to: CGPoint(x: (w + neckWidth) / 2, y: neckHeight * 0.65),
            control: CGPoint(x: (w + neckWidth) / 2 + w * 0.06, y: neckHeight + shoulderHeight * 0.3)
        )
        p.addLine(to: CGPoint(x: (w + neckWidth) / 2, y: 0))
        p.closeSubpath()
        return p
    }
}
