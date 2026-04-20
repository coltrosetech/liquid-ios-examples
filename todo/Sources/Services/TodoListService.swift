import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class TodoListService {
    var tasks: [TodoTask] = []
    var isLoading = false

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func loadToday() {
        isLoading = true
        defer { isLoading = false }
        let descriptor = FetchDescriptor<TodoTask>(
            sortBy: [SortDescriptor(\.dueAt), SortDescriptor(\.createdAt)]
        )
        tasks = (try? context.fetch(descriptor)) ?? []
    }

    func toggle(_ task: TodoTask) {
        task.isDone.toggle()
        try? context.save()
    }

    func add(title: String, dueAt: Date? = nil, tag: String? = nil) {
        let task = TodoTask(title: title, dueAt: dueAt, tag: tag)
        context.insert(task)
        try? context.save()
        loadToday()
    }

    var doneCount: Int { tasks.filter(\.isDone).count }
    var totalCount: Int { tasks.count }
}
