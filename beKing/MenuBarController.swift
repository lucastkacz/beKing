import Cocoa

final class MenuBarController {
    private let statusItem: NSStatusItem
    private let menu = NSMenu()
    private let presenter: PromptWindowHost
    private let preferencesPresenter: PreferencesWindowHost   // <-- add

    init(promptPresenter: PromptWindowHost,
         preferencesPresenter: PreferencesWindowHost) {
        self.presenter = promptPresenter
        self.preferencesPresenter = preferencesPresenter
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

        let prefsItem = NSMenuItem(title: "Preferences…", action: #selector(openPreferences(_:)), keyEquivalent: ",")
        prefsItem.target = self

        let quitItem = NSMenuItem(title: "Quit beKing", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self

        menu.items = [showItem, prefsItem, .separator(), quitItem]
        statusItem.menu = menu
    }

    // MARK: - Actions
    
    @objc private func showPromptNow(_ sender: Any?) {
        presenter.show()
    }

    @objc private func quit(_ sender: Any?) {
        NSApp.terminate(nil)
    }
    
    @objc private func openPreferences(_ sender: Any?) {
        preferencesPresenter.show()
    }
}
