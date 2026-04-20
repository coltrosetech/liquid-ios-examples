import SwiftUI

struct AddTaskSheet: View {
    let service: TodoListService?
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var dueAt: Date = .now
    @State private var includeDueDate = false
    @State private var tag = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task", text: $title, axis: .vertical)
                        .lineLimit(1...3)
                }
                Section {
                    Toggle("Due time", isOn: $includeDueDate)
                    if includeDueDate {
                        DatePicker("When", selection: $dueAt, displayedComponents: [.hourAndMinute])
                    }
                    TextField("#tag (optional)", text: $tag)
                        .font(.system(.body, design: .monospaced))
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("New task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { addAndDismiss() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func addAndDismiss() {
        let cleanTag = tag.trimmingCharacters(in: .whitespaces)
        service?.add(
            title: title,
            dueAt: includeDueDate ? dueAt : nil,
            tag: cleanTag.isEmpty ? nil : cleanTag
        )
        dismiss()
    }
}
