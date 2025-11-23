import Cocoa

final class MenuBarController {
    private let statusItem: NSStatusItem
    private let menu = NSMenu()
    private let presenter: PromptWindowHost
    private let preferencesPresenter: PreferencesWindowHost
    private let historyPresenter: HistoryWindowHost

    init(promptPresenter: PromptWindowHost,
         preferencesPresenter: PreferencesWindowHost,
         historyPresenter: HistoryWindowHost) {
        self.presenter = promptPresenter
        self.preferencesPresenter = preferencesPresenter
        self.historyPresenter = historyPresenter
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
        
        let historyItem = NSMenuItem(title: "Journal History…", action: #selector(openHistory), keyEquivalent: "")
        historyItem.target = self

        let prefsItem = NSMenuItem(title: "Preferences…", action: #selector(openPreferences), keyEquivalent: ",")
        prefsItem.target = self

        let quitItem = NSMenuItem(title: "Quit beKing", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self

        menu.items = [
            showItem,
            .separator(),
            historyItem,
            prefsItem,
            .separator(),
            quitItem
        ]
        statusItem.menu = menu
    }

    // MARK: - Actions
    
    @objc private func showPromptNow() {
        presenter.show()
    }
    
    @objc private func openHistory() {
        historyPresenter.show()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
    
    @objc private func openPreferences() {
        preferencesPresenter.show()
    }
}
