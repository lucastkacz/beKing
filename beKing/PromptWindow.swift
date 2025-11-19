import SwiftUI

struct PromptWindow: View {
    let prompt: Prompt
    let onLike: () -> Void
    let onDislike: () -> Void
    let onJournal: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(prompt.text)
                .font(.title3)
                .padding(.top, 4)

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

                if let onJournal = onJournal {
                    Spacer()
                    Button(action: {
                        onJournal()
                    }) {
                        Label("Write", systemImage: "square.and-pencil")
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(20)
        .frame(width: 420, height: 200)
    }

    private var title: String {
        switch prompt.type {
        case .affirmation: return "Affirmation"
        case .journal:     return "Journal Prompt"
        case .action:      return "Action"
        }
    }
}
