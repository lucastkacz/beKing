import Foundation

enum AppSettingsKeys {
    static let schedulerEnabled = "schedulerEnabled"
    static let schedulerIntervalHours = "schedulerIntervalHours"
    static let launchAtLoginEnabled = "launchAtLoginEnabled"
    static let includeAffirmations = "includeAffirmations"
    static let includeJournalPrompts = "includeJournalPrompts"
    static let includeActionPrompts = "includeActionPrompts"
}

struct AppSettings {
    var schedulerEnabled: Bool
    var schedulerIntervalHours: Int

    static let `default` = AppSettings(
        schedulerEnabled: true,
        schedulerIntervalHours: 4
    )

    static func load() -> AppSettings {
        let defaults = UserDefaults.standard

        let enabled = defaults.object(forKey: AppSettingsKeys.schedulerEnabled) as? Bool
            ?? AppSettings.default.schedulerEnabled

        let hours = defaults.object(forKey: AppSettingsKeys.schedulerIntervalHours) as? Int
            ?? AppSettings.default.schedulerIntervalHours

        return AppSettings(schedulerEnabled: enabled, schedulerIntervalHours: max(hours, 1))
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(schedulerEnabled, forKey: AppSettingsKeys.schedulerEnabled)
        defaults.set(schedulerIntervalHours, forKey: AppSettingsKeys.schedulerIntervalHours)
    }
}

extension Notification.Name {
    static let schedulerSettingsDidChange = Notification.Name("SchedulerSettingsDidChange")
}
