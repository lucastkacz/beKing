# Task 1: Bootstrap App Skeleton

This initial task focused on creating the fundamental skeleton of a macOS menu-bar application using a modern, hybrid SwiftUI and AppKit architecture.

### 1. Feature Overview

The goal was to create a functional, menu-bar-only application shell. This involved setting up the app to run without a Dock icon and creating the status bar item with a basic menu.

### 2. Key Functionalities

-   **Menu-Bar-Only Application:** The app was configured to run as a background agent, showing only an icon in the system menu bar, not in the Dock.
-   **Status Icon and Menu:** A 👑 icon was added to the menu bar. Clicking it reveals a menu with three initial actions: "Show Prompt Now," "Preferences…", and "Quit."
-   **Placeholder Windows:**
    -   The "Show Prompt Now" action opens a single, reusable placeholder window.
    -   The "Preferences…" action was wired to open the standard SwiftUI `Settings` scene, which was initially empty.
-   **Window Management:** The foundation for managing window lifecycles was established, ensuring that only one instance of the prompt window can be open at a time and that it can be dismissed via standard controls (e.g., the close button, ⌘W).

### 3. File Changes

#### New or Significantly Modified Files

-   `beKing.xcodeproj/project.pbxproj`: Modified to include the `LSUIElement` key in the `Info.plist` file, which enables the app to run without a Dock icon.
-   `beKingApp.swift`: The `@main` entry point was modified to use `@NSApplicationDelegateAdaptor` and to declare a `Settings` scene instead of a `WindowGroup`, preventing a window from appearing on launch.
-   `AppDelegate.swift`: Created to act as the bridge between the SwiftUI app lifecycle and AppKit. It's responsible for instantiating and owning the `MenuBarController`.
-   `MenuBarController.swift`: Created to manage the `NSStatusItem` (the menu bar icon) and its associated `NSMenu`.
-   `PromptWindow.swift`: A placeholder SwiftUI view for the prompt popup.
-   `PromptWindowHost.swift`: A custom controller created to manage the `NSWindow` that hosts the `PromptWindow` view, establishing a reusable pattern for window management.

### 4. Architectural Decisions & Notes

-   A **hybrid SwiftUI + AppKit architecture** was chosen, which is the standard for modern macOS apps requiring platform-specific features like `NSStatusItem`.
-   The **"Window Host" pattern** was established to encapsulate `NSWindow` management logic, keeping AppKit code cleanly separated from SwiftUI views.
-   **Dependency Injection** was used to provide the `PromptWindowHost` to the `MenuBarController`, creating a decoupled and testable relationship between the components.
