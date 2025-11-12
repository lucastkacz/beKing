//
//  MenuBarController.swift
//  beKing
//
//  Created by Lucas Tkacz on 12/11/2025.
//

import Cocoa

final class MenuBarController {
    private let statusItem: NSStatusItem

    init() {
        // Variable-length status item; suitable for icon + text if needed later.
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // Use an SF Symbol crown for now; template so it auto adapts to dark/light.
            button.image = NSImage(systemSymbolName: "crown", accessibilityDescription: "beKing")
            button.image?.isTemplate = true
            // (No action yet; next step we’ll attach a menu.)
        }
    }
}
