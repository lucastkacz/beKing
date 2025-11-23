// beKing/Sources/Journal/HistoryWindowHost.swift

import Cocoa
import SwiftUI

final class HistoryWindowHost {
    private var window: NSWindow?
    private let promptRepository: PromptRepository

    init(promptRepository: PromptRepository) {
        self.promptRepository = promptRepository
    }

    func show() {
        if let win = window {
            win.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let controller = NSHostingController(rootView: HistoryView(promptRepository: promptRepository))
        let win = NSWindow(contentViewController: controller)
        
        win.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        win.title = "beKing Journal History"
        win.isReleasedWhenClosed = false
        win.center()
        win.setFrameAutosaveName("HistoryWindow")
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
}
