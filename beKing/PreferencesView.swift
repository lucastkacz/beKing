import SwiftUI

struct PreferencesView: View {
    @AppStorage(AppSettingsKeys.schedulerEnabled)
    private var schedulerEnabled: Bool = AppSettings.default.schedulerEnabled

    @AppStorage(AppSettingsKeys.schedulerIntervalHours)
    private var schedulerIntervalHours: Int = AppSettings.default.schedulerIntervalHours

    @AppStorage(AppSettingsKeys.launchAtLoginEnabled)
    private var launchAtLoginEnabled: Bool = false   // default off

    var body: some View {
        TabView {
            schedulerTab
                .tabItem {
                    Label("Triggers", systemImage: "clock")
                }
            generalTab
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
        }
        .padding()
        .frame(width: 480, height: 260)   // same for both tabs
        .onChange(of: schedulerEnabled) {
            notifySchedulerSettingsChanged()
        }
        .onChange(of: schedulerIntervalHours) {
            notifySchedulerSettingsChanged()
        }
        .onChange(of: launchAtLoginEnabled) {
            LaunchAtLogin.setEnabled(launchAtLoginEnabled)
        }
    }

    // MARK: - Triggers tab

    private var schedulerTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Enable automatic prompts", isOn: $schedulerEnabled)

            HStack {
                Text("Interval (hours)")
                Spacer()
                Stepper("\(schedulerIntervalHours) h",
                        value: $schedulerIntervalHours,
                        in: 1...24)
                    .monospacedDigit()
            }

            Text("Prompts will appear approximately every \(schedulerIntervalHours) hour(s) while the app is running.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
    }

    // MARK: - General tab

    private var generalTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("beKing")
                    .font(.title2.bold())
                Text("Lightweight menu-bar companion for self-improvement prompts.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            Toggle("Open beKing at login", isOn: $launchAtLoginEnabled)

            Spacer()

            Text("v0.2.0 (dev)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func notifySchedulerSettingsChanged() {
        NotificationCenter.default.post(name: .schedulerSettingsDidChange, object: nil)
    }
}
