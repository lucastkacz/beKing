import Cocoa

/// Listens for macOS wake events and triggers a callback.
final class WakeListener {
    private var observer: NSObjectProtocol?
    private let onWake: () -> Void

    init(onWake: @escaping () -> Void) {
        self.onWake = onWake
    }

    /// Start listening for wake notifications.
    func start() {
        guard observer == nil else { return }

        observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            NSLog("[beKing] WakeListener: didWakeNotification received")
            self.onWake()
        }
    }

    /// Stop listening (optional for now, but nice to have).
    func stop() {
        if let token = observer {
            NSWorkspace.shared.notificationCenter.removeObserver(token)
            observer = nil
        }
    }

    deinit {
        stop()
    }
}
