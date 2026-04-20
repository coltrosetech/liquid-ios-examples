import SwiftUI
import SwiftData

struct GardenView: View {
    @Environment(\.modelContext) private var context
    @State private var garden: Garden?
    @State private var showingAdd = false
    @State private var celebratingPlant: Plant?
    @State private var dropPulse = false

    var body: some View {
        // swiftui:source — DNA gradient bg cream-to-mint
        NavigationStack {
            ZStack {
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

                if let garden {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            header(garden: garden)
                            section(title: "THIRSTY 🥺", plants: garden.thirsty, garden: garden)
                            section(title: "HAPPY ✨", plants: garden.happy, garden: garden)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                } else {
                    ProgressView()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .bottomTrailing) { addFAB }
            .sheet(isPresented: $showingAdd) {
                if let garden {
                    // swiftui:source — DNA decision: sheet medium detent for fast task
                    AddPlantSheet(garden: garden)
                        .presentationDetents([.medium, .large])
                }
            }
        }
        .task { @MainActor in
            if garden == nil {
                garden = Garden(context: context)
            }
            garden?.reload()
        }
    }

    private func header(garden: Garden) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("My garden 🌿")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Text("\(garden.thirsty.count) thirsty · \(garden.happy.count) happy")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            // swiftui:source — prototype "drop counter pop animation on tap"
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    dropPulse.toggle()
                }
            } label: {
                HStack(spacing: 4) {
                    Text("💧").font(.system(size: 16))
                    Text("\(garden.dropsEarned)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white, in: Capsule())
                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                .scaleEffect(dropPulse ? 1.15 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: dropPulse)
            }
            .buttonStyle(.plain)
        }
    }

    private func section(title: String, plants: [Plant], garden: Garden) -> some View {
        Group {
            if !plants.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    // swiftui:source — prototype "ForEach(plants) { PlantCard }"
                    ForEach(plants) { plant in
                        PlantCard(plant: plant, isCelebrating: celebratingPlant?.id == plant.id) {
                            water(plant: plant, garden: garden)
                        }
                    }
                }
            }
        }
    }

    private func water(plant: Plant, garden: Garden) {
        garden.water(plant)
        celebratingPlant = plant
        // Reset celebration after the bounce completes
        Task {
            try? await Task.sleep(for: .milliseconds(700))
            await MainActor.run {
                if celebratingPlant?.id == plant.id { celebratingPlant = nil }
                garden.reload()
            }
        }
    }

    private var addFAB: some View {
        Button {
            showingAdd = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color(red: 0.36, green: 0.75, blue: 0.38), in: Circle())
                .shadow(color: Color(red: 0.36, green: 0.75, blue: 0.38).opacity(0.4), radius: 16, y: 4)
        }
        .buttonStyle(.scaleEffectStyle)
        .padding(20)
    }
}

// MARK: - PlantCard

struct PlantCard: View {
    let plant: Plant
    let isCelebrating: Bool
    let onWater: () -> Void

    var body: some View {
        // swiftui:source — prototype "PlantCard with thirst indicator + water button"
        HStack(spacing: 14) {
            // swiftui:source — prototype "phaseAnimator wiggle on plant emoji"
            Text(plant.emoji)
                .font(.system(size: 36))
                .phaseAnimator([0, 1, 2]) { content, phase in
                    content.rotationEffect(.degrees(phase == 0 ? -2 : (phase == 1 ? 0 : 2)))
                } animation: { _ in
                    .easeInOut(duration: 1.5)
                }
                // swiftui:source — celebration bounce on water tap
                .scaleEffect(isCelebrating ? 1.3 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isCelebrating)

            VStack(alignment: .leading, spacing: 2) {
                Text(plant.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text(metadata)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)

                // swiftui:source — prototype "thirst bar — animated width"
                ThirstBar(level: plant.thirstLevel)
                    .padding(.top, 6)
            }

            // swiftui:source — water button only on thirsty
            if plant.isThirsty {
                Button(action: onWater) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color(red: 0.36, green: 0.75, blue: 0.38), in: Circle())
                        .shadow(color: Color(red: 0.36, green: 0.75, blue: 0.38).opacity(0.3), radius: 8, y: 4)
                }
                .buttonStyle(.scaleEffectStyle)
            } else {
                Text("in \(plant.nextWaterIn)d")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }

    private var metadata: String {
        let days = plant.daysSinceWatered
        let dayText = days == 0 ? "today" : days == 1 ? "yesterday" : "\(days) days ago"
        return "\(plant.species) · last watered \(dayText)"
    }
}

// MARK: - ThirstBar

struct ThirstBar: View {
    let level: Double  // 0.0 to 2.0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.06))
                Capsule()
                    .fill(thirstGradient)
                    .frame(width: max(0, min(level, 1.0)) * geo.size.width)
                    // swiftui:source — prototype "transition: width 400ms spring"
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: level)
            }
        }
        .frame(height: 6)
    }

    private var thirstGradient: LinearGradient {
        if level >= 0.85 {
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.51, blue: 0.40), Color(red: 1.0, green: 0.37, blue: 0.36)],
                startPoint: .leading, endPoint: .trailing
            )
        } else if level >= 0.5 {
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.72, blue: 0.36), Color(red: 1.0, green: 0.51, blue: 0.40)],
                startPoint: .leading, endPoint: .trailing
            )
        } else {
            return LinearGradient(
                colors: [Color(red: 0.36, green: 0.75, blue: 0.38), Color(red: 0.36, green: 0.75, blue: 0.38)],
                startPoint: .leading, endPoint: .trailing
            )
        }
    }
}

// MARK: - Button style

private struct ScaleEffectStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // swiftui:source — prototype ".plant-card:active { transform: scale(0.96) }"
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScaleEffectStyle {
    static var scaleEffectStyle: ScaleEffectStyle { ScaleEffectStyle() }
}
