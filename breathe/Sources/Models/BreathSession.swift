import Foundation
import SwiftData

enum BreathPattern: String, Codable, CaseIterable {
    case box = "Box breathing"
    case fourSevenEight = "4-7-8 calm"
    case focusReset = "Focus reset"

    var inhaleSeconds: Double {
        switch self {
        case .box: return 4
        case .fourSevenEight: return 4
        case .focusReset: return 5
        }
    }

    var holdSeconds: Double {
        switch self {
        case .box: return 4
        case .fourSevenEight: return 7
        case .focusReset: return 0
        }
    }

    var exhaleSeconds: Double {
        switch self {
        case .box: return 4
        case .fourSevenEight: return 8
        case .focusReset: return 5
        }
    }

    var emoji: String {
        switch self {
        case .box: return "🌊"
        case .fourSevenEight: return "🌙"
        case .focusReset: return "🌿"
        }
    }
}

@Model
final class BreathSession {
    var pattern: BreathPattern
    var startedAt: Date
    var durationSeconds: Int
    var completed: Bool

    init(pattern: BreathPattern, durationSeconds: Int = 300) {
        self.pattern = pattern
        self.startedAt = Date()
        self.durationSeconds = durationSeconds
        self.completed = false
    }
}
