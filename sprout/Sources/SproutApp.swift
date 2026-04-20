import SwiftUI
import SwiftData

@main
struct SproutApp: App {
    let container: ModelContainer = {
        let container = try! ModelContainer(for: Plant.self)
        #if DEBUG
        // Seed with realistic demo data on first launch (for screenshots / first-run experience)
        let context = container.mainContext
        let count = (try? context.fetchCount(FetchDescriptor<Plant>())) ?? 0
        if count == 0 {
            let seeds: [(String, String, String, Int, Int)] = [
                // name, species, emoji, intervalDays, daysAgoWatered
                ("Mona",   "Monstera",        "🌱", 7, 6),
                ("Felix",  "Fiddle leaf fig", "🪴", 5, 4),
                ("Spike",  "Cactus",          "🌵", 14, 2),
                ("Pothos", "Pothos",          "🌿", 7, 1),
            ]
            for (name, species, emoji, interval, daysAgo) in seeds {
                let p = Plant(name: name, species: species, emoji: emoji, wateringIntervalDays: interval)
                p.lastWateredAt = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
                context.insert(p)
            }
            try? context.save()
        }
        #endif
        return container
    }()

    var body: some Scene {
        WindowGroup {
            GardenView()
        }
        .modelContainer(container)
    }
}
