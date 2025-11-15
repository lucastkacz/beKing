import Cocoa
import SwiftUI

final class PreferencesWindowHost {
    private var window: NSWindow?

    func show() {
        if let win = window {
            win.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let controller = NSHostingController(rootView: PreferencesView())

        let win = NSWindow(
            contentViewController: controller
        )
        win.styleMask = [.titled, .closable, .miniaturizable]
        win.title = "beKing Preferences"
        win.isReleasedWhenClosed = false
        win.center()
        win.setFrameAutosaveName("PreferencesWindow")
        win.makeKeyAndOrderFront(nil)

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
