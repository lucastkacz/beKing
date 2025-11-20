import SwiftUI

struct JournalEditorView: View {
    let prompt: Prompt
    let onSave: (String) -> Void
    let onCancel: () -> Void

    @State private var text: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Journal entry")
                .font(.headline)

            Text(prompt.text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)

            TextEditor(text: $text)
                .font(.body)
                .border(Color(nsColor: .separatorColor), width: 1)

            HStack {
                Spacer()
                Button("Cancel") {
                    onCancel()
                }
                Button("Save") {
                    onSave(text)
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .frame(width: 480, height: 260)
    }
}
