//
//  MuscleSelectionGrid.swift
//  HealthLife
//
//  Created by Antonio Almeida on 13/12/25.
//

import SwiftUI

struct MuscleSelectionGrid<MuscleType: Identifiable & Hashable>: View {
    let allMuscles: [MuscleType]
    let selected: Set<MuscleType>
    let toggle: (MuscleType) -> Void

    // Optional label provider: default uses String(describing:)
    private let labelProvider: (MuscleType) -> String

    init(
        allMuscles: [MuscleType],
        selected: Set<MuscleType>,
        toggle: @escaping (MuscleType) -> Void,
        label: @escaping (MuscleType) -> String = { String(describing: $0) }
    ) {
        self.allMuscles = allMuscles
        self.selected = selected
        self.toggle = toggle
        self.labelProvider = label
    }

    // Grid layout: 2 or 3 columns depending on width
    private func columns(for width: CGFloat) -> [GridItem] {
        // Aim for minimum item width ~120
        let minItemWidth: CGFloat = 120
        let rawCount = Int(width / minItemWidth)
        let count = max(2, rawCount)

        var items: [GridItem] = []
        items.reserveCapacity(count)
        for _ in 0..<count {
            let item = GridItem(.flexible(minimum: minItemWidth), spacing: 12, alignment: .leading)
            items.append(item)
        }
        return items
    }

    var body: some View {
        GeometryReader { proxy in
            let cols: [GridItem] = columns(for: proxy.size.width)
            LazyVGrid(columns: cols, alignment: .leading, spacing: 12) {
                ForEach(allMuscles) { muscle in
                    let isOn = selected.contains(muscle)
                    MuscleRow(
                        title: labelProvider(muscle),
                        isOn: isOn
                    ) {
                        toggle(muscle)
                    }
                    .accessibilityLabel(labelProvider(muscle))
                    .accessibilityValue(isOn ? Text("Selected") : Text("Not selected"))
                }
            }
        }
        .frame(minHeight: 44) // ensure it renders with some height
    }
}

private struct MuscleRow: View {
    let title: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isOn ? Color.accentColor : .secondary)
                Text(title)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(backgroundShape)
            .overlay(borderShape)
        }
        .buttonStyle(.plain)
    }

    private var backgroundShape: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(isOn ? Color.accentColor.opacity(0.15) : Color.primary.opacity(0.06))
    }

    private var borderShape: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .strokeBorder(isOn ? Color.accentColor.opacity(0.7) : Color.primary.opacity(0.25), lineWidth: 1)
    }
}

//extension MuscleSelectionGrid where MuscleType == GymView.Muscle {
//    init(
//        allMuscles: [GymView.Muscle],
//        selected: Set<GymView.Muscle>,
//        toggle: @escaping (GymView.Muscle) -> Void
//    ) {
//        self.init(
//            allMuscles: allMuscles,
//            selected: selected,
//            toggle: toggle,
//            label: { $0.displayName }
//        )
//    }
//}

#Preview("MuscleSelectionGrid") {
    // Simple preview using GymView.Muscle
    struct Demo: View {
        @State var selected: Set<GymView.Muscle> = [.chest, .biceps]
        var body: some View {
            MuscleSelectionGrid(
                allMuscles: GymView.Muscle.allCases,
                selected: selected,
                toggle: { m in
                    if selected.contains(m) { selected.remove(m) } else { selected.insert(m) }
                }
            )
            .padding()
        }
    }
    return Demo()
}
