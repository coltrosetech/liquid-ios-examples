import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @State private var log: SessionLog?
    @State private var showingSession = false

    var body: some View {
        NavigationStack {
            ZStack {
                // swiftui:source — prototype gradient bg "linear-gradient sky-to-sunset"
                LinearGradient(
                    colors: [
                        Color(red: 0.71, green: 0.83, blue: 0.94),
                        Color(red: 0.88, green: 0.83, blue: 0.94),
                        Color(red: 0.94, green: 0.83, blue: 0.88)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if let log {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            header
                            BreathOrb()
                            startButton
                            recentSection(log: log)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    }
                } else {
                    ProgressView()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .fullScreenCover(isPresented: $showingSession) {
                // swiftui:source — DNA decision: fullScreenCover for deep focus
                if let log {
                    SessionView(pattern: .box) { completed in
                        if completed { log.record(BreathSession(pattern: .box)) }
                        showingSession = false
                    }
                }
            }
        }
        .task { @MainActor in
            if log == nil {
                log = SessionLog(context: context)
            }
            log?.loadRecent()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(.primary.opacity(0.85))
            Text("Five minutes can change a day.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Late night?"
        }
    }

    // swiftui:source — prototype "Button with .glassEffect background"
    private var startButton: some View {
        Button {
            showingSession = true
        } label: {
            Text("Start a 5-minute session")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary.opacity(0.85))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .buttonStyle(.scaleEffectStyle)
        .background {
            // swiftui:source — prototype ".glassEffect() | fallback .ultraThinMaterial"
            if #available(iOS 26.0, *) {
                RoundedRectangle(cornerRadius: 16)
                    .glassEffect()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            }
        }
    }

    private func recentSection(log: SessionLog) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECENT SESSIONS")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)

            // swiftui:source — prototype "ForEach(sessions) SessionCard"
            ForEach(log.sessions) { session in
                SessionCard(session: session)
            }
        }
    }
}

// MARK: - BreathOrb

struct BreathOrb: View {
    @State private var phase = 0

    var body: some View {
        // swiftui:source — prototype "Circle().fill(...).glassEffect()" wrapper
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.9), Color.white.opacity(0.4)],
                        center: .topLeading,
                        startRadius: 5,
                        endRadius: 200
                    )
                )
                .frame(width: 220, height: 220)
                .background {
                    if #available(iOS 26.0, *) {
                        Circle().glassEffect()
                    } else {
                        Circle().fill(.ultraThinMaterial)
                    }
                }
                .shadow(color: Color.blue.opacity(0.3), radius: 30, y: 10)

            // swiftui:source — prototype "phaseAnimator scale 0.85↔1.0 8s ease-in-out"
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.9), Color(red: 0.47, green: 0.63, blue: 0.94).opacity(0.7)],
                        center: .topLeading,
                        startRadius: 5,
                        endRadius: 100
                    )
                )
                .frame(width: 160, height: 160)
                .shadow(color: Color(red: 0.47, green: 0.63, blue: 0.94).opacity(0.6), radius: 40)
                .phaseAnimator([0, 1]) { content, phase in
                    content.scaleEffect(phase == 0 ? 0.85 : 1.0)
                } animation: { _ in
                    .easeInOut(duration: 4)
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .overlay(alignment: .bottom) {
            Text("Inhale… exhale…")
                .font(.system(size: 16, weight: .regular, design: .serif))
                .italic()
                .foregroundStyle(.secondary)
                .offset(y: 24)
        }
    }
}

// MARK: - SessionCard

struct SessionCard: View {
    let session: BreathSession

    var body: some View {
        // swiftui:source — prototype "SessionCard with .glassEffect()"
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(session.pattern.rawValue)
                    .font(.system(size: 15, weight: .medium))
                Text(metadata)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            if #available(iOS 26.0, *) {
                RoundedRectangle(cornerRadius: 16)
                    .glassEffect()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            }
        }
    }

    private var metadata: String {
        let date = relative(session.startedAt)
        let time = session.startedAt.formatted(.dateTime.hour().minute())
        let mins = session.durationSeconds / 60
        return "\(date) · \(time) · \(mins) min"
    }

    private func relative(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        return date.formatted(.dateTime.weekday(.abbreviated))
    }
}

// MARK: - Button style

private struct ScaleEffectStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // swiftui:source — prototype ".session-card:active { transform: scale(0.97) }"
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.7, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScaleEffectStyle {
    static var scaleEffectStyle: ScaleEffectStyle { ScaleEffectStyle() }
}
