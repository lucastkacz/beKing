//
//  beKingApp.swift
//  beKing
//
//  Created by Lucas Tkacz on 11/11/2025.
//

import SwiftUI

@main
struct beKingApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No initial windows. We'll add Preferences later to this Settings scene.
        Settings {
            EmptyView()
        }
    }
}
