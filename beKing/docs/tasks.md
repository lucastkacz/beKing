# beKing — Development Roadmap

This document outlines the major, feature-centric tasks for building the beKing application.

---

### ✅ Task 1: Bootstrap App Skeleton

Create the fundamental skeleton of a macOS menu-bar application.
- **Goals:**
  - Configure the app to run without a Dock icon.
  - Create the menu bar icon and a functional menu (`Show Prompt`, `Preferences`, `Quit`).
  - Implement placeholder windows for the prompt and preferences.
  - Establish the "Window Host" pattern for managing window lifecycles.
- **Status:** Complete.

---

### ✅ Task 2: Scheduling & Persistence Layer

Implement the systems for automatic prompt delivery and data persistence.
- **Goals:**
  - Build a robust storage utility for reading/writing JSON data to the app's sandboxed container.
  - Create type-safe "Store" objects for `ratings.json` and `journal.json`.
  - Implement an interval-based `Scheduler` and a system `WakeListener` for automatic triggers.
  - Implement the "Launch at Login" feature.
  - Integrate all features with a functional `PreferencesView`.
- **Status:** Complete.

---

### ✅ Task 3: Prompt Engine & Core Interaction

Build the logic for selecting prompts and make the prompt window fully interactive.
- **Goals:**
  - Create a `PromptEngine` with a weighted random selection algorithm based on user ratings.
  - Implement prompt category filtering based on user preferences.
  - Wire up "Like" / "Dislike" buttons to persist ratings.
  - Implement the inline journaling UI (`TextEditor`) and save functionality.
- **Status:** Complete.

---

### ✅ Task 4: Journal History & Enhancements

Create a feature-rich browser for users to review and export their journal entries.
- **Goals:**
  - ✅ Build a master-detail window to browse all journal entries.
  - ✅ Display the original prompt text for context.
  - ✅ Implement real-time, case-insensitive search.
  - ✅ Add sorting controls (Newest/Oldest First).
  - ✅ Implement JSON export.
  - ✅ Implement CSV export.
- **Status:** Complete.

---

### ✅ Task 5: Action Prompts (Mic & Camera)

Implement the interactive "Action" prompt types.
- **Goals:**
  - **Microphone:** For "Speak affirmation" prompts, request mic permission, record a short audio clip, and provide a playback option.
  - **Camera:** For "Smile challenge" prompts, request camera permission, show a live preview, and capture a still image.
  - Update the `PromptWindow` to dynamically display the appropriate UI for these new types.
  - Ensure graceful handling of cases where permission is denied.
- **Status:** Complete.

---

### ⏳ Task 6: Finalization & Polish

Prepare the application for a V1 release.
- **Goals:**
  - **Privacy Controls:** Add a "Delete All Data" button in Preferences.
  - **App Icon:** Create and assign a proper, high-resolution application icon.
  * **Error Handling:** Conduct a full review of error handling paths (e.g., file IO, permissions) to ensure the app never crashes unexpectedly.
  - **Accessibility:** Perform a review to ensure all UI elements have VoiceOver labels and are navigable.
  - **Packaging:** Configure signing and prepare the app for distribution (e.g., as a `.dmg` file).
- **Status:** In Progress.

---

### 🚀 Future Tasks (Post-V1)

-   **Remote Prompt Source:** Implement fetching prompts from a remote URL to deliver new content without app updates.
-   **Cloud Sync:** Use iCloud/CloudKit to sync journal entries and ratings across a user's devices.
-   **Custom Prompts:** Allow users to add their own prompts to the engine.
-   **Themes & Customization:** Add more appearance settings.