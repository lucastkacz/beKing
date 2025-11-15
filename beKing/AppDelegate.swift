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
    private var scheduler: Scheduler?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("[beKing] App launched")

        self.menuBarController = MenuBarController(promptPresenter: promptHost)

        // TEMP: create scheduler and start a test interval (e.g. every 30 seconds)
        scheduler = Scheduler { [weak self] in
            NSLog("[beKing] Scheduler fired - showing prompt")
            self?.promptHost.show()
        }

        // For development, use a short interval; later we'll take this from settings.
        scheduler?.scheduleEvery(seconds: 30)
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSLog("[beKing] App will terminate")
    }
    
    
}
