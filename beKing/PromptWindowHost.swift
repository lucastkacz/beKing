import Cocoa
import SwiftUI

final class PromptWindowHost {

    private var window: NSWindow?
    private let promptEngine = PromptEngine()

    func show() {
        guard let prompt = promptEngine.nextPrompt() else {
            return
        }

        let view = PromptWindow(
            prompt: prompt,
            onLike: { [weak self] in
                self?.promptEngine.recordLike(for: prompt)
            },
            onDislike: { [weak self] in
                self?.promptEngine.recordDislike(for: prompt)
            },
            onJournal: nil   // we’ll hook this later
        )

        if let existingWindow = window,
           let hosting = existingWindow.contentViewController as? NSHostingController<PromptWindow> {
            hosting.rootView = view
        } else {
            let hosting = NSHostingController(rootView: view)
            let w = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 420, height: 200),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            w.center()
            w.title = "beKing Prompt"
            w.contentViewController = hosting
            w.isReleasedWhenClosed = false

            self.window = w
        }

        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
