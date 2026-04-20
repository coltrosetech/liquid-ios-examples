import SwiftUI
import SwiftData

@main
struct TodoApp: App {
    let container: ModelContainer = {
        let container = try! ModelContainer(for: TodoTask.self)
        #if DEBUG
        let context = container.mainContext
        let count = (try? context.fetchCount(FetchDescriptor<TodoTask>())) ?? 0
        if count == 0 {
            let cal = Calendar.current
            let seeds: [(String, String?, Int?)] = [
                ("Finish quarterly review doc", "work", 0),
                ("Reply to Sarah about the offsite", "work", 0),
                ("Pick up dry cleaning", "errand", 0),
                ("Book dentist appointment", "health", 2),
                ("Read chapter 4 of Kleppmann", "learn", nil),
                ("Water the plants", "home", nil),
            ]
            for (title, tag, daysFromNow) in seeds {
                let due = daysFromNow.flatMap { cal.date(byAdding: .day, value: $0, to: Date()) }
                let task = TodoTask(title: title, dueAt: due, tag: tag)
                context.insert(task)
            }
            try? context.save()
        }
        #endif
        return container
    }()

    var body: some Scene {
        WindowGroup {
            TodayView()
        }
        .modelContainer(container)
    }
}
