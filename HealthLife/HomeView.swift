//
//  HomeView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 29/11/25.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    headerView

                    // Feature cards
                    VStack(spacing: 16) {
                        NavigationLink(destination: HydrationView()) {
                            HydrationCard()
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: GymView()) {
                            GymCard()
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: BodyMeasurementsView()) {
                            BodyMeasurementsCard()
                        }
                        .buttonStyle(.plain)
                    }

                    // Spacer to push logout near bottom when content is short
                    Spacer(minLength: 12)

                    // Add a flexible spacer to force the logout button to the bottom
                    Spacer()

                    // Logout
                    logoutButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity) // expand width so Spacer works as expected
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .background(backgroundView.ignoresSafeArea())
        }
    }

    // MARK: - Subviews
    private var headerView: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.blue.opacity(colorScheme == .dark ? 0.25 : 0.18))
                    .frame(width: 56, height: 56)

                Image(systemName: "heart.text.square.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.blue)
                    .font(.system(size: 28, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 4) {
                // Compose the welcome with username if available
                let name = authenticationManager.username
                Text(name?.isEmpty == false ? "Welcome to Health Life, \(name!)!" : "Welcome to Health Life")
                    .font(.title3).bold()
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)

                Text("Track your daily health habits.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.top, 4)
    }

    private var logoutButton: some View {
        Button(role: .destructive) {
            authenticationManager.logout()
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.body)
                Text("Logout")
                    .font(.body.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.red.opacity(0.12))
            )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("logout_button")
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(colorScheme == .dark ? 0.95 : 0.02),
                Color.blue.opacity(colorScheme == .dark ? 0.15 : 0.06)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Feature Cards

private struct HydrationCard: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(cardBackground)

            // Content
            HStack(spacing: 16) {
                // Icon bubble
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(colorScheme == .dark ? 0.25 : 0.18))
                        .frame(width: 56, height: 56)

                    Image(systemName: "drop.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .font(.system(size: 26, weight: .semibold))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Hydration")
                        .font(.headline)
                    Text("Log your water intake and view history.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Accessory chevron
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .overlay(
            // Subtle border
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.12), radius: 10, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Hydration. Log your water intake to ensure you're hidrated.")
    }

    private var cardBackground: some ShapeStyle {
        LinearGradient(
            colors: [
                Color.primary.opacity(colorScheme == .dark ? 0.08 : 0.04),
                Color.blue.opacity(colorScheme == .dark ? 0.20 : 0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct GymCard: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(cardBackground)

            // Content
            HStack(spacing: 16) {
                // Icon bubble
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(colorScheme == .dark ? 0.25 : 0.18))
                        .frame(width: 56, height: 56)

                    Image(systemName: gymIconName)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.green)
                        .font(.system(size: 26, weight: .semibold))
                        .accessibilityHidden(true)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Gym")
                        .font(.headline)
                    Text("Log workouts and know which muscle you should train today.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Accessory chevron
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.12), radius: 10, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Gym. Plan workouts and track your training.")
    }

    private var cardBackground: some ShapeStyle {
        LinearGradient(
            colors: [
                Color.primary.opacity(colorScheme == .dark ? 0.08 : 0.04),
                Color.green.opacity(colorScheme == .dark ? 0.20 : 0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // Choose a gym-like symbol; "dumbbell.fill" (iOS 17+) or fallback "figure.strength".
    private var gymIconName: String {
        if #available(iOS 17.0, *) {
            return "dumbbell.fill"
        } else {
            return "figure.strength"
        }
    }
}

private struct BodyMeasurementsCard: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(cardBackground)

            // Content
            HStack(spacing: 16) {
                // Icon bubble
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(colorScheme == .dark ? 0.25 : 0.18))
                        .frame(width: 56, height: 56)

                    Image(systemName: bodyIconName)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.purple)
                        .font(.system(size: 26, weight: .semibold))
                        .accessibilityHidden(true)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Body Measurements")
                        .font(.headline)
                    Text("Track your measurements and weight.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Accessory chevron
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.12), radius: 10, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Body Measures. Track your body measurements.")
    }

    private var cardBackground: some ShapeStyle {
        LinearGradient(
            colors: [
                Color.primary.opacity(colorScheme == .dark ? 0.08 : 0.04),
                Color.purple.opacity(colorScheme == .dark ? 0.20 : 0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var bodyIconName: String {
        if #available(iOS 17.0, *) {
            return "figure.arms.open"
        } else {
            return "figure.wave.circle"
        }
    }
}

#Preview("Home") {
    HomeView()
        .environmentObject(AuthenticationManager())
}
