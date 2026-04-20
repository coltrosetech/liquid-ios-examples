import Foundation
import SwiftData

@Model
final class TodoTask {
    var title: String
    var isDone: Bool
    var dueAt: Date?
    var tag: String?
    var createdAt: Date

    init(title: String, dueAt: Date? = nil, tag: String? = nil) {
        self.title = title
        self.isDone = false
        self.dueAt = dueAt
        self.tag = tag
        self.createdAt = Date()
    }
}
