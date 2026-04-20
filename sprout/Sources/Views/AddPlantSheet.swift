import SwiftUI

struct AddPlantSheet: View {
    let garden: Garden
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var species = ""
    @State private var emoji = "🌱"
    @State private var intervalDays = 7

    private let emojiChoices = ["🌱", "🌿", "🪴", "🌵", "🌴", "🌷", "🌻", "🌹", "🍀", "🌾"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Plant identity") {
                    TextField("Name (e.g. Mona)", text: $name)
                        .font(.system(.body, design: .rounded))
                    TextField("Species (e.g. Monstera)", text: $species)
                        .font(.system(.body, design: .rounded))
                }

                Section {
                    // swiftui:source — DNA decision: emoji picker (character bond)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                        ForEach(emojiChoices, id: \.self) { choice in
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    emoji = choice
                                }
                            } label: {
                                Text(choice)
                                    .font(.system(size: 32))
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Circle()
                                            .fill(emoji == choice ? Color(red: 0.36, green: 0.75, blue: 0.38).opacity(0.2) : Color.clear)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(emoji == choice ? Color(red: 0.36, green: 0.75, blue: 0.38) : Color.clear, lineWidth: 2)
                                    )
                                    .scaleEffect(emoji == choice ? 1.1 : 1.0)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Pick a face")
                }

                Section("Watering schedule") {
                    Stepper(value: $intervalDays, in: 1...30) {
                        HStack {
                            Text("Every")
                            Text("\(intervalDays)")
                                .font(.system(.body, design: .rounded).bold())
                                .foregroundStyle(Color(red: 0.36, green: 0.75, blue: 0.38))
                            Text(intervalDays == 1 ? "day" : "days")
                        }
                        .font(.system(.body, design: .rounded))
                    }
                }
            }
            .navigationTitle("New plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { addAndDismiss() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func addAndDismiss() {
        let cleanName = name.trimmingCharacters(in: .whitespaces)
        let cleanSpecies = species.trimmingCharacters(in: .whitespaces).isEmpty ? "Plant" : species
        garden.add(name: cleanName, species: cleanSpecies, emoji: emoji, intervalDays: intervalDays)
        dismiss()
    }
}
