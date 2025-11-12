//
//  AppDelegate.swift
//  beKing
//
//  Created by Lucas Tkacz on 12/11/2025.
//

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    // We’ll create and keep our status bar controller here later.
    private var menuBarController: MenuBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("[beKing] App launched")
        self.menuBarController = MenuBarController()
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSLog("[beKing] App will terminate")
    }
}
