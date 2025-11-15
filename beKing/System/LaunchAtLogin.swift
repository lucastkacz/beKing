import Foundation
import ServiceManagement

enum LaunchAtLogin {
    /// Returns true if the main app is registered as a login item.
    static var isEnabled: Bool {
        switch SMAppService.mainApp.status {
        case .enabled:
            return true
        case .notRegistered, .requiresApproval, .notFound:
            return false
        @unknown default:
            return false
        }
    }

    /// Try to enable or disable launch at login.
    static func setEnabled(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
                NSLog("[beKing] LaunchAtLogin: registered main app")
            } else {
                try SMAppService.mainApp.unregister()
                NSLog("[beKing] LaunchAtLogin: unregistered main app")
            }
        } catch {
            NSLog("[beKing] LaunchAtLogin error: \(error)")
        }
    }
}
