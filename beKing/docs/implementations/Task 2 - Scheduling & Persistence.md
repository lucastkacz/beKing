# Task 2: Scheduling & Persistence

This task transformed the static app skeleton into a dynamic application by adding a persistence layer for storing data and implementing automatic triggers for showing prompts.

### 1. Feature Overview

The goal was to enable the app to save data between launches and to show prompts automatically based on time or system events, with settings configurable by the user.

### 2. Key Functionalities

-   **Persistence Layer:** A robust and reusable storage system was built to save and load data.
    -   It writes files to the app's sandboxed **Application Support** directory.
    -   It handles JSON encoding and decoding for any `Codable` type.
-   **Data Stores:** Specific "Store" objects were created to manage the persistence of `ratings.json` and `journal.json`.
-   **Automatic Triggers:**
    -   **Interval Scheduler:** A `Scheduler` class was built to show prompts at a user-defined hourly interval using a `Timer`.
    -   **Wake Trigger:** A `WakeListener` class was implemented to show a prompt whenever the Mac wakes from sleep, using `NSWorkspace.didWakeNotification`.
-   **Launch at Login:** The app can now be configured to launch automatically when the user logs in, using the modern `SMAppService` framework.
-   **Settings Integration:** The new features are fully integrated with the Preferences window. Users can enable/disable the scheduler, set the interval, and toggle the "Open at login" feature. Changes made in the UI are immediately reflected in the app's behavior.

### 3. File Changes

#### New Files Created

-   `Storage.swift`: A generic, reusable utility for all JSON file I/O.
-   `System/JournalStore.swift`: Manages the persistence of `JournalEntry` objects.
-   `System/RatingStore.swift`: Manages the persistence of prompt rating scores.
-   `System/Scheduler.swift`: The class responsible for handling time-based interval triggers.
-   `System/WakeListener.swift`: The class that listens for system wake notifications.
-   `System/LaunchAtLogin.swift`: A clean wrapper around the `SMAppService` framework.
-   `System/AppSettings.swift`: A centralized location for `UserDefaults` keys and a typed struct for app settings.

#### Existing Files Modified

-   `AppDelegate.swift`: Updated to own and manage the lifecycle of the `Scheduler` and `WakeListener`. It also now observes notifications from the `PreferencesView` to reconfigure the scheduler on the fly.
-   `PreferencesView.swift`: Significantly updated with a `TabView` and UI controls (`Toggle`, `Stepper`) to allow user configuration of all the new features. It uses `@AppStorage` for persistence and posts notifications when settings change.

### 4. Architectural Decisions & Notes

-   A **layered storage architecture** was implemented: a generic `Storage` utility at the bottom, with type-safe `JournalStore` and `RatingsStore` objects providing a clean API to the rest of the app.
-   **Decoupled Services:** The `Scheduler` and `WakeListener` were built as standalone classes that are owned by the `AppDelegate` and use closures for callbacks, preventing tight coupling with other parts of the application.
-   **Reactive Settings:** Communication between the `PreferencesView` and the `AppDelegate` was implemented using `NotificationCenter`. This is a robust pattern that allows the UI to signal changes without needing a direct reference to the services it's affecting.
