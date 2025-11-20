import Cocoa
import SwiftUI

final class JournalWindowHost {

    private var window: NSWindow?

    func show(for prompt: Prompt) {
        let view = JournalEditorView(
            prompt: prompt,
            onSave: { [weak self] text in
                self?.saveEntry(text: text, prompt: prompt)
                self?.window?.close()
            },
            onCancel: { [weak self] in
                self?.window?.close()
            }
        )

        if let existingWindow = window,
           let hosting = existingWindow.contentViewController as? NSHostingController<JournalEditorView> {
            hosting.rootView = view
        } else {
            let hosting = NSHostingController(rootView: view)
            let w = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 480, height: 260),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            w.center()
            w.title = "Journal"
            w.contentViewController = hosting
            w.isReleasedWhenClosed = false

            self.window = w
        }

        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func saveEntry(text: String, prompt: Prompt) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            NSLog("[beKing] Journal: empty text, not saving")
            return
        }

        let entry = JournalEntry(
            id: UUID(),
            promptId: prompt.id,
            date: Date(),
            text: text
        )

        JournalStore.append(entry)
        NSLog("[beKing] Journal: saved entry for prompt \(prompt.id)")
    }
}
