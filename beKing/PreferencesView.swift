import SwiftUI

struct PreferencesView: View {
    @AppStorage(AppSettingsKeys.schedulerEnabled)
    private var schedulerEnabled: Bool = AppSettings.default.schedulerEnabled

    @AppStorage(AppSettingsKeys.schedulerIntervalHours)
    private var schedulerIntervalHours: Int = AppSettings.default.schedulerIntervalHours
    
    private func notifySchedulerSettingsChanged() {
        NotificationCenter.default.post(name: .schedulerSettingsDidChange, object: nil)
    }
    
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
        .frame(width: 420, height: 260)
        .onChange(of: schedulerEnabled) {
            notifySchedulerSettingsChanged()
        }
        .onChange(of: schedulerIntervalHours) {
            notifySchedulerSettingsChanged()
        }
    }

    private var schedulerTab: some View {
        Form {
            Toggle("Enable automatic prompts", isOn: $schedulerEnabled)

            HStack {
                Text("Interval (hours)")
                Spacer()
                Stepper(value: $schedulerIntervalHours, in: 1...24) {
                    Text("\(schedulerIntervalHours) h")
                }
                .frame(width: 140)
            }
            Text("Prompts will appear approximately every \(schedulerIntervalHours) hour(s) while the app is running.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private var generalTab: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("beKing")
                .font(.title2.bold())
            Text("Lightweight menu-bar companion for self-improvement prompts.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text("v0.2.0 (dev)")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
    }
}
