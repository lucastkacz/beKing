import Cocoa

final class MenuBarController {
    private let statusItem: NSStatusItem
    private let menu = NSMenu()

    init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "crown", accessibilityDescription: "beKing")
            button.image?.isTemplate = true
        }

        buildMenu()
    }

    private func buildMenu() {
        let showItem = NSMenuItem(title: "Show Prompt Now", action: #selector(showPromptNow), keyEquivalent: "")
        showItem.target = self

        let prefsItem = NSMenuItem(title: "Preferences…", action: #selector(openPreferences), keyEquivalent: ",")
        prefsItem.target = self

        let quitItem = NSMenuItem(title: "Quit beKing", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self

        menu.items = [showItem, prefsItem, .separator(), quitItem]
        statusItem.menu = menu
    }

    // MARK: - Actions
    @objc private func showPromptNow() {
        NSLog("[beKing] Show Prompt Now (stub)")
        // Next increment: open a tiny SwiftUI window.
    }

    @objc private func openPreferences() {
        // This triggers the SwiftUI Settings scene window (macOS 13+).
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
