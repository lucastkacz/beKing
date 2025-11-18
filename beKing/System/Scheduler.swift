import Foundation

/// Handles time-based triggers to show prompts.
final class Scheduler {
    enum Mode {
        case off
        case interval(hours: Int)
        // future: case calendar(weekdays: Set<Int>, time: DateComponents)
    }

    private var timer: Timer?
    private let onFire: () -> Void
    private(set) var mode: Mode = .off

    init(onFire: @escaping () -> Void) {
        self.onFire = onFire
    }

    /// Schedule a repeating timer that fires every `hours`.
    func scheduleInterval(hours: Int) {
        guard hours > 0 else {
            stop()
            return
        }

        mode = .interval(hours: hours)
        installTimer(interval: TimeInterval(hours * 3600))
    }

    /// Stop all scheduled triggers.
    func stop() {
        mode = .off
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Private

    private func installTimer(interval: TimeInterval) {
        // Invalidate any existing timer
        timer?.invalidate()

        // Use main run loop so it's safe with UI updates
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.onFire()
        }

        // Optional: allow the system some flexibility for power savings
        timer?.tolerance = interval * 0.1
    }
}

extension Scheduler {
    /// Development/testing helper: schedule by seconds instead of hours.
    func scheduleEvery(seconds: TimeInterval) {
        guard seconds > 0 else {
            stop()
            return
        }
        mode = .off  // or a dedicated dev mode if you want
        installTimer(interval: seconds)
    }
}
