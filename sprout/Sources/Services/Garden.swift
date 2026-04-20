import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class Garden {
    var plants: [Plant] = []
    var dropsEarned: Int = 0  // gamification: each watering earns a drop

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func reload() {
        let descriptor = FetchDescriptor<Plant>(
            sortBy: [SortDescriptor(\.createdAt)]
        )
        plants = (try? context.fetch(descriptor)) ?? []
    }

    func add(name: String, species: String, emoji: String, intervalDays: Int) {
        let plant = Plant(name: name, species: species, emoji: emoji, wateringIntervalDays: intervalDays)
        context.insert(plant)
        try? context.save()
        reload()
    }

    func water(_ plant: Plant) {
        plant.lastWateredAt = Date()
        dropsEarned += 1
        try? context.save()
    }

    func remove(_ plant: Plant) {
        context.delete(plant)
        try? context.save()
        reload()
    }

    var thirsty: [Plant] { plants.filter { $0.isThirsty } }
    var happy: [Plant] { plants.filter { !$0.isThirsty } }
}
