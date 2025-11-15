//
//  AppDelegate.swift
//  beKing
//
//  Created by Lucas Tkacz on 12/11/2025.
//

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarController: MenuBarController?
    private let promptHost = PromptWindowHost()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("[beKing] App launched")
        self.menuBarController = MenuBarController(promptPresenter: promptHost)
        
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSLog("[beKing] App will terminate")
    }
    
    
}
