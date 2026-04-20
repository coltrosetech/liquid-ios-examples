import SwiftUI
import SwiftData

@main
struct BreatheApp: App {
    var body: some Scene {
        WindowGroup {
            TodayView()
        }
        .modelContainer(for: BreathSession.self)
    }
}
