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
    private let preferencesHost = PreferencesWindowHost()   // <-- new
    private var scheduler: Scheduler?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("[beKing] App launched")

        self.menuBarController = MenuBarController(
            promptPresenter: promptHost,
            preferencesPresenter: preferencesHost
        )

        // Scheduler uses app settings
        let settings = AppSettings.load()
        scheduler = Scheduler { [weak self] in
            NSLog("[beKing] Scheduler fired - showing prompt")
            self?.promptHost.show()
        }

        if settings.schedulerEnabled {
            scheduler?.scheduleInterval(hours: settings.schedulerIntervalHours)
        } else {
            scheduler?.stop()
        }

        NSLog("[beKing] Scheduler initial config: enabled=\(settings.schedulerEnabled), interval=\(settings.schedulerIntervalHours)h")
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSLog("[beKing] App will terminate")
    }
    
    
}
