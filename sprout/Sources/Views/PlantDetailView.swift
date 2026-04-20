import SwiftUI
import Charts

struct PlantDetailView: View {
    let plant: Plant
    let garden: Garden
    @Environment(\.dismiss) private var dismiss
    @State private var celebrating = false

    var body: some View {
        ZStack {
            // swiftui:source — DNA gradient continues from GardenView
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.98, blue: 0.90),
                    Color(red: 0.90, green: 0.96, blue: 0.88),
                    Color(red: 0.98, green: 0.98, blue: 0.94)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    hero
                    statusPill
                        .padding(.top, 8)
                    waterButton
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    historySection
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                    scheduleCard
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
        }
        // swiftui:source — prototype: back arrow + edit/delete menu in top bar
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Edit", systemImage: "pencil") { }
                    Button("Remove", systemImage: "trash", role: .destructive) {
                        garden.remove(plant)
                        dismiss()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(.white, in: Circle())
                        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                }
            }
        }
    }

    // swiftui:source — prototype "hero: big plant + name"
    private var hero: some View {
        VStack(spacing: 16) {
            Text(plant.emoji)
                .font(.system(size: 100))
                // swiftui:source — phaseAnimator wiggle (continuous)
                .phaseAnimator([0, 1, 2]) { content, phase in
                    content.rotationEffect(.degrees(phase == 0 ? -2 : (phase == 1 ? 0 : 2)))
                } animation: { _ in
                    .easeInOut(duration: 2)
                }
                // swiftui:source — celebration bounce on Water tap
                .scaleEffect(celebrating ? 1.3 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: celebrating)

            VStack(spacing: 4) {
                Text(plant.name)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Text(plant.species)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 24)
    }

    // swiftui:source — prototype "Status pill — thirst-aware color"
    private var statusPill: some View {
        let isThirsty = plant.isThirsty
        return HStack(spacing: 6) {
            Text(isThirsty ? "🥺" : "✨")
            Text(statusText)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(
                isThirsty
                ? Color(red: 1.0, green: 0.37, blue: 0.36).opacity(0.12)
                : Color(red: 0.36, green: 0.75, blue: 0.38).opacity(0.12)
            )
        )
        .foregroundStyle(isThirsty ? Color(red: 0.83, green: 0.27, blue: 0.27) : Color(red: 0.16, green: 0.55, blue: 0.18))
    }

    private var statusText: String {
        let days = plant.daysSinceWatered
        if plant.isThirsty {
            return "Thirsty — \(days) day\(days == 1 ? "" : "s") since last drink"
        } else {
            return "Happy — water in \(plant.nextWaterIn) day\(plant.nextWaterIn == 1 ? "" : "s")"
        }
    }

    // swiftui:source — prototype "Water now — big CTA"
    private var waterButton: some View {
        Button(action: water) {
            HStack(spacing: 8) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 20))
                Text("Water now")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
        }
        .buttonStyle(.scaleEffectStyle)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.36, green: 0.75, blue: 0.38))
                .shadow(color: Color(red: 0.36, green: 0.75, blue: 0.38).opacity(0.4), radius: 20, y: 8)
        )
    }

    // swiftui:source — prototype "Last 14 days bar chart"
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LAST 14 DAYS")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .tracking(0.5)

            let history = generateHistory(days: 14)

            VStack {
                // swiftui:source — Charts framework BarMark
                Chart(history) { day in
                    BarMark(
                        x: .value("Day", day.daysAgo),
                        y: .value("Days since", day.daysSinceWatered)
                    )
                    .foregroundStyle(barColor(for: day))
                    .cornerRadius(3)
                }
                .frame(height: 100)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)

                Text(historySummary)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            .padding(20)
            .background(.white, in: RoundedRectangle(cornerRadius: 22))
            .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
        }
    }

    // swiftui:source — prototype "Schedule card"
    private var scheduleCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SCHEDULE")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .tracking(0.5)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Water every \(plant.wateringIntervalDays) days")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                    Text("Next reminder in \(plant.nextWaterIn) day\(plant.nextWaterIn == 1 ? "" : "s")")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Edit") { /* edit flow */ }
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 0.36, green: 0.75, blue: 0.38))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(Color(red: 0.36, green: 0.75, blue: 0.38).opacity(0.15))
                    )
                    .buttonStyle(.plain)
            }
            .padding(18)
            .background(.white, in: RoundedRectangle(cornerRadius: 22))
            .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
        }
    }

    private func water() {
        garden.water(plant)
        celebrating = true
        Task {
            try? await Task.sleep(for: .milliseconds(700))
            await MainActor.run { celebrating = false }
        }
    }

    private func generateHistory(days: Int) -> [WateringDay] {
        // Stub: in real impl, derive from a watering log model. For prototype matching,
        // produce a pattern with two waterings (4 days apart, 8 days apart) and current at 6.
        (0..<days).map { i in
            let daysAgo = days - 1 - i
            let watered = daysAgo == 12 || daysAgo == 5
            let bar = watered ? Double(plant.wateringIntervalDays) : Double(plant.daysSinceWatered) / 14.0 * Double(daysAgo)
            return WateringDay(daysAgo: daysAgo, daysSinceWatered: bar, watered: watered)
        }
    }

    private func barColor(for day: WateringDay) -> Color {
        if day.watered { return Color(red: 0.36, green: 0.75, blue: 0.38) }
        if day.daysAgo == 0 && plant.isThirsty {
            return Color(red: 1.0, green: 0.37, blue: 0.36)
        }
        return Color.black.opacity(0.05)
    }

    private var historySummary: String {
        let waterings = (0..<14).filter { $0 % 7 == 0 }.count
        return "\(waterings) waterings · avg \(plant.wateringIntervalDays)d apart"
    }
}

private struct WateringDay: Identifiable {
    let daysAgo: Int
    let daysSinceWatered: Double
    let watered: Bool
    var id: Int { daysAgo }
}

private struct ScaleEffectStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScaleEffectStyle {
    static var scaleEffectStyle: ScaleEffectStyle { ScaleEffectStyle() }
}
