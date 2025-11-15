import Foundation

enum AppSettingsKeys {
    static let schedulerEnabled = "schedulerEnabled"
    static let schedulerIntervalHours = "schedulerIntervalHours"
}

struct AppSettings {
    var schedulerEnabled: Bool
    var schedulerIntervalHours: Int

    // Default configuration
    static let `default` = AppSettings(
        schedulerEnabled: true,
        schedulerIntervalHours: 4
    )

    // Load from UserDefaults
    static func load() -> AppSettings {
        let defaults = UserDefaults.standard

        let enabled = defaults.object(forKey: AppSettingsKeys.schedulerEnabled) as? Bool
            ?? AppSettings.default.schedulerEnabled

        let hours = defaults.object(forKey: AppSettingsKeys.schedulerIntervalHours) as? Int
            ?? AppSettings.default.schedulerIntervalHours

        return AppSettings(schedulerEnabled: enabled, schedulerIntervalHours: max(hours, 1))
    }

    // Save to UserDefaults
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(schedulerEnabled, forKey: AppSettingsKeys.schedulerEnabled)
        defaults.set(schedulerIntervalHours, forKey: AppSettingsKeys.schedulerIntervalHours)
    }
}

extension Notification.Name {
    static let schedulerSettingsDidChange = Notification.Name("SchedulerSettingsDidChange")
}
