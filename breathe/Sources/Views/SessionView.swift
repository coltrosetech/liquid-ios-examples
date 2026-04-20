import SwiftUI

struct SessionView: View {
    let pattern: BreathPattern
    let onFinish: (Bool) -> Void

    @State private var phase: Phase = .inhale
    @State private var elapsed: TimeInterval = 0
    @State private var remaining: TimeInterval = 300
    @Environment(\.dismiss) private var dismiss

    enum Phase { case inhale, hold, exhale }

    var body: some View {
        ZStack {
            // swiftui:source — DNA gradient continues into session view
            LinearGradient(
                colors: [Color(red: 0.71, green: 0.83, blue: 0.94), Color(red: 0.88, green: 0.83, blue: 0.94)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()
                Text(phaseLabel)
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary.opacity(0.85))
                    .contentTransition(.opacity)

                // Re-uses the BreathOrb pattern
                BreathOrb()
                    .frame(height: 280)

                Text(remainingLabel)
                    .font(.system(.title3, design: .monospaced))
                    .foregroundStyle(.secondary)
                Spacer()

                Button("End session") {
                    onFinish(false)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.bottom, 24)
            }
            .padding()
        }
        .task { runCycle() }
    }

    private var phaseLabel: String {
        switch phase {
        case .inhale: return "Breathe in…"
        case .hold:   return "Hold."
        case .exhale: return "Breathe out…"
        }
    }

    private var remainingLabel: String {
        let m = Int(remaining) / 60
        let s = Int(remaining) % 60
        return String(format: "%d:%02d", m, s)
    }

    @MainActor
    private func runCycle() {
        Task {
            while remaining > 0 {
                phase = .inhale
                try? await Task.sleep(for: .seconds(pattern.inhaleSeconds))
                if pattern.holdSeconds > 0 {
                    phase = .hold
                    try? await Task.sleep(for: .seconds(pattern.holdSeconds))
                }
                phase = .exhale
                try? await Task.sleep(for: .seconds(pattern.exhaleSeconds))
                let cycle = pattern.inhaleSeconds + pattern.holdSeconds + pattern.exhaleSeconds
                remaining -= cycle
            }
            onFinish(true)
        }
    }
}
