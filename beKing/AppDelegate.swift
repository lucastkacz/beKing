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

        // Initial scheduler config from settings
        configureSchedulerFromSettings()

        // Listen for live changes coming from PreferencesView
        NotificationCenter.default.addObserver(
            forName: .schedulerSettingsDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.configureSchedulerFromSettings()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSLog("[beKing] App will terminate")
    }
    
    private func configureSchedulerFromSettings() {
        let settings = AppSettings.load()

        if scheduler == nil {
            scheduler = Scheduler { [weak self] in
                NSLog("[beKing] Scheduler fired - showing prompt")
                self?.promptHost.show()
            }
        }

        if settings.schedulerEnabled {
            scheduler?.scheduleInterval(hours: settings.schedulerIntervalHours)
            NSLog("[beKing] Scheduler reconfigured: enabled=true, interval=\(settings.schedulerIntervalHours)h")
        } else {
            scheduler?.stop()
            NSLog("[beKing] Scheduler reconfigured: enabled=false")
        }
    }
    
    
}
