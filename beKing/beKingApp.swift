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
        // Keep ContentView for now (we won’t show a window at launch later)
        WindowGroup {
            ContentView()
        }
        // In a pure menu-bar utility we’ll eventually remove this WindowGroup,
        // but leaving it now keeps development simple while we bootstrap.
    }
}
