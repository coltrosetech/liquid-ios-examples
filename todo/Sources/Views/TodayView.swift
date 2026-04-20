import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @State private var service: TodoListService?
    @State private var showingAddSheet = false

    var body: some View {
        // swiftui:source — prototype line "NavigationStack root"
        NavigationStack {
            content
                .navigationTitle("Today")
                .navigationBarTitleDisplayMode(.large)
                .overlay(alignment: .bottomTrailing) { addButton }
                .sheet(isPresented: $showingAddSheet) {
                    AddTaskSheet(service: service)
                        .presentationDetents([.medium])
                }
        }
        .task { @MainActor in
            if service == nil {
                service = TodoListService(context: context)
            }
            service?.loadToday()
        }
    }

    @ViewBuilder
    private var content: some View {
        if let service {
            VStack(alignment: .leading, spacing: 0) {
                // swiftui:source — prototype line "3 of 7 done" subtitle
                Text("\(service.doneCount) of \(service.totalCount) done")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                // swiftui:source — prototype "List with hairline separators"
                List {
                    ForEach(service.tasks) { task in
                        TaskRow(task: task) {
                            service.toggle(task)
                        }
                        .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                }
                .listStyle(.plain)
            }
        } else {
            ProgressView()
        }
    }

    // swiftui:source — prototype "FloatingActionButton — Button with .scaleEffect on press"
    private var addButton: some View {
        Button {
            showingAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentColor, in: Circle())
                .shadow(color: Color.accentColor.opacity(0.3), radius: 12, y: 4)
        }
        .buttonStyle(.scaleEffectStyle)
        .padding(16)
    }
}

struct TaskRow: View {
    let task: TodoTask
    let onToggle: () -> Void

    var body: some View {
        // swiftui:source — prototype "row with .background(...).animation(.easeInOut(duration: 0.3))"
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 16) {
                Checkbox(isChecked: task.isDone)
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(.system(size: 15, weight: .medium))
                        .strikethrough(task.isDone)
                        .foregroundStyle(task.isDone ? .secondary : .primary)
                        .opacity(task.isDone ? 0.4 : 1.0)
                    if let due = task.dueAt {
                        Text(metadata(for: due, tag: task.tag))
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        // swiftui:source — prototype L113 ".animation(.easeInOut(duration: 0.3), value: isSelected)"
        .animation(.easeInOut(duration: 0.3), value: task.isDone)
    }

    private func metadata(for date: Date, tag: String?) -> String {
        let f = Date.FormatStyle.dateTime.hour().minute()
        let timeString = date.formatted(f)
        if let tag { return "\(timeString) · #\(tag)" }
        return timeString
    }
}

private struct Checkbox: View {
    let isChecked: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.secondary.opacity(0.4), lineWidth: 1.5)
                .frame(width: 20, height: 20)
            if isChecked {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.accentColor)
                    .frame(width: 20, height: 20)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        // swiftui:source — prototype "transition all 200ms ease-in-out" on .checkbox
        .animation(.easeInOut(duration: 0.3), value: isChecked)
    }
}

// MARK: - Button style

private struct ScaleEffectStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // swiftui:source — prototype ".fab:active { transform: scale(0.94) }"
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScaleEffectStyle {
    static var scaleEffectStyle: ScaleEffectStyle { ScaleEffectStyle() }
}
