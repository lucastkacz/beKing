import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarController: MenuBarController?
    private let promptHost = PromptWindowHost()
    private let preferencesHost = PreferencesWindowHost()
    private let historyHost: HistoryWindowHost // Changed to non-private let
    private let promptRepository = PromptRepository() // Add this
    private var scheduler: Scheduler?
    private var wakeListener: WakeListener?

    override init() { // Add this initializer
        self.historyHost = HistoryWindowHost(promptRepository: promptRepository)
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("[beKing] App launched")

        self.menuBarController = MenuBarController(
            promptPresenter: promptHost,
            preferencesPresenter: preferencesHost,
            historyPresenter: historyHost
        )
        
        let repo = PromptRepository()
        NSLog("[beKing] First prompt is: \(repo.allPrompts.first?.text ?? "none")")

        // Sync launch-at-login toggle from system status on launch
        let isLoginItemEnabled = LaunchAtLogin.isEnabled
        UserDefaults.standard.set(isLoginItemEnabled, forKey: AppSettingsKeys.launchAtLoginEnabled)
        NSLog("[beKing] LaunchAtLogin initial status: \(isLoginItemEnabled)")

        // Initial scheduler config + reactive observer
        configureSchedulerFromSettings()
        NotificationCenter.default.addObserver(
            forName: .schedulerSettingsDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.configureSchedulerFromSettings()
        }

        // Wake listener
        wakeListener = WakeListener { [weak self] in
            NSLog("[beKing] WakeListener: showing prompt after wake")
            self?.promptHost.show()
        }
        wakeListener?.start()
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
