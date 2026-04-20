import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class SessionLog {
    var sessions: [BreathSession] = []
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func loadRecent(limit: Int = 8) {
        var descriptor = FetchDescriptor<BreathSession>(
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        sessions = (try? context.fetch(descriptor)) ?? []
    }

    func record(_ session: BreathSession) {
        context.insert(session)
        try? context.save()
        loadRecent()
    }

    func markComplete(_ session: BreathSession) {
        session.completed = true
        try? context.save()
    }
}
