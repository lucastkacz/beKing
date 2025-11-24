import SwiftUI

struct PromptWindow: View {
    let prompt: Prompt
    let audioService: AudioService
    let cameraService: CameraService
    let onLike: () -> Void
    let onDislike: () -> Void
    let onSaveJournal: ((String) -> Void)?
    let onComplete: () -> Void

    @State private var journalText: String = ""
    @State private var savedMessageVisible = false

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
            } else if prompt.type == .action {
                ActionPromptView(
                    audioService: audioService,
                    cameraService: cameraService,
                    prompt: prompt,
                    onComplete: onComplete
                )
            }
            
            if savedMessageVisible {
                Text("Saved!")
                    .foregroundColor(.green)
                    .font(.footnote)
                    .padding(.top, 4)
            }

            Spacer(minLength: 0)

            HStack {
                Button(action: onLike) {
                    Label("Like", systemImage: "hand.thumbsup")
                }

                Button(action: onDislike) {
                    Label("Dislike", systemImage: "hand.thumbsdown")
                }

                if prompt.type == .journal, let onSaveJournal = onSaveJournal {
                    Spacer()
                    Button("Save") {
                        let trimmed = journalText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        onSaveJournal(trimmed)
                        journalText = ""
                        savedMessageVisible = true
                        // Hide after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            savedMessageVisible = false
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding(.top, 8)
        }
        .padding(20)
        // Dynamically adjust height for different prompt types
        .frame(width: 480, height: prompt.type == .action ? 320 : (prompt.type == .journal ? 320 : 200))
    }

    private var title: String {
        switch prompt.type {
        case .affirmation: return "Affirmation"
        case .journal:     return "Journal Prompt"
        case .action:      return "Action Prompt"
        }
    }
}