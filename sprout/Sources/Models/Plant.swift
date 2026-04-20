import Foundation
import SwiftData

@Model
final class Plant {
    var name: String
    var species: String
    var emoji: String
    var wateringIntervalDays: Int
    var lastWateredAt: Date
    var createdAt: Date

    init(name: String, species: String, emoji: String, wateringIntervalDays: Int) {
        self.name = name
        self.species = species
        self.emoji = emoji
        self.wateringIntervalDays = wateringIntervalDays
        self.lastWateredAt = Date()
        self.createdAt = Date()
    }

    /// 0.0 = just watered, 1.0 = fully due, > 1.0 = overdue
    var thirstLevel: Double {
        let elapsed = Date().timeIntervalSince(lastWateredAt)
        let interval = TimeInterval(wateringIntervalDays) * 86_400
        return min(elapsed / interval, 2.0)
    }

    var daysSinceWatered: Int {
        let elapsed = Date().timeIntervalSince(lastWateredAt)
        return Int(elapsed / 86_400)
    }

    var isThirsty: Bool { thirstLevel >= 0.85 }

    var nextWaterIn: Int {
        let remaining = wateringIntervalDays - daysSinceWatered
        return max(remaining, 0)
    }
}
