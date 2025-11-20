import SwiftUI

struct PromptWindow: View {
    let prompt: Prompt
    let onLike: () -> Void
    let onDislike: () -> Void
    let onSaveJournal: ((String) -> Void)?   // new

    @State private var journalText: String = ""      // used only for .journal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(prompt.text)
                .font(.title3)
                .padding(.top, 4)

            if prompt.type == .journal {
                TextEditor(text: $journalText)
                    .font(.body)
                    .border(Color(nsColor: .separatorColor), width: 1)
                    .frame(minHeight: 120)
                    .padding(.top, 8)
            }

            Spacer(minLength: 0)

            HStack {
                Button(action: {
                    onLike()
                }) {
                    Label("Like", systemImage: "hand.thumbsup")
                }

                Button(action: {
                    onDislike()
                }) {
                    Label("Dislike", systemImage: "hand.thumbsdown")
                }

                if prompt.type == .journal, let onSaveJournal = onSaveJournal {
                    Spacer()
                    Button("Save") {
                        let trimmed = journalText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        onSaveJournal(trimmed)
                        journalText = ""   // clear after save
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding(.top, 8)
        }
        .padding(20)
        .frame(width: 480, height: prompt.type == .journal ? 320 : 200)
    }

    private var title: String {
        switch prompt.type {
        case .affirmation: return "Affirmation"
        case .journal:     return "Journal Prompt"
        case .action:      return "Action"
        }
    }
}
