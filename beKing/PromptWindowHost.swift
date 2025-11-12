import Cocoa
import SwiftUI

// Handles Esc by closing the window.
final class PromptHostingController: NSHostingController<PromptWindow> {
    override func cancelOperation(_ sender: Any?) {
        self.view.window?.performClose(nil)
    }
}

final class PromptWindowHost {
    private var window: NSWindow?

    func show() {
        if let win = window {
            win.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let controller = PromptHostingController(rootView: PromptWindow())
        let win = NSWindow(
            contentViewController: controller
        )
        win.styleMask = [.titled, .closable, .miniaturizable]  // ⌘W works by default
        win.title = "beKing Prompt"
        win.isReleasedWhenClosed = false
        win.center()
        win.setFrameAutosaveName("PromptWindow")
        win.makeKeyAndOrderFront(nil)

        // Keep reference and clean up when closed
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: win,
            queue: .main
        ) { [weak self] _ in
            self?.window = nil
        }

        self.window = win
        NSApp.activate(ignoringOtherApps: true)
    }

    func close() {
        window?.performClose(nil)
    }
}
