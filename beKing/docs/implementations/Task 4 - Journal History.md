# Task 4: Journal History & Export

**Date Completed:** November 23, 2025

### 1. Feature Overview

This task involved creating a dedicated feature for users to browse, read, and export their entire journal history. A new "Journal History..." item was added to the main menu bar to launch this feature in its own resizable window.

### 2. Key Functionalities

-   **History Browser:** A master-detail interface was implemented using SwiftUI's `HSplitView`.
    -   The **master list** on the left displays all journal entries, showing the date, the original prompt text (retrieved via the `PromptRepository`), and a preview of the user's entry.
    -   The **detail view** on the right displays the full, scrollable text of the selected journal entry.
-   **JSON Export:**
    -   An "Export to JSON..." button was added to the window's toolbar.
    -   This feature uses an `NSSavePanel` to allow the user to choose a save location and filename.
    -   The entire journal history is encoded into a human-readable JSON format, using the standard ISO 8601 format for dates to ensure portability.
-   **User Feedback:** The export feature provides visual feedback via an `Alert` upon success or failure. User-cancellations of the save panel are handled silently as a non-error case.

### 3. File Changes

#### New Files Created

-   `beKing/docs/implementations/Task 4 - Journal History.md`: This documentation file.
-   `beKing/Sources/Journal/HistoryView.swift`: The main SwiftUI view for the history browser UI.
-   `beKing/Sources/Journal/HistoryWindowHost.swift`: The AppKit window controller responsible for managing the history window's lifecycle.
-   `beKing/Sources/Journal/JournalExporter.swift`: A dedicated utility struct that encapsulates all logic for encoding journal entries and handling the file export process.

#### Existing Files Modified

-   `beKing/AppDelegate.swift`: Updated to instantiate and manage the lifecycle of `HistoryWindowHost` and `PromptRepository`, injecting them as dependencies down the chain.
-   `beKing/MenuBarController.swift`: Modified to include the "Journal History..." menu item and wire it to the `HistoryWindowHost`.
-   `beKing/System/JournalStore.swift`: The `JournalEntry` struct was updated to conform to `Hashable` to support selection in SwiftUI's `List`.

### 4. Architectural Decisions & Notes

-   **Dependency Injection:** The `PromptRepository` was passed down through the `AppDelegate` -> `HistoryWindowHost` -> `HistoryView` chain. This maintains a clean, testable architecture where views are not responsible for creating their own dependencies.
-   **Dedicated Exporter:** Logic for exporting was placed in a separate `JournalExporter` struct. This follows the Single Responsibility Principle, keeping the `HistoryView` focused on presentation and the `JournalExporter` focused on data processing and file I/O.
-   **App Sandbox Entitlement:** A critical project-level change was required. The **User Selected File** capability in the App Sandbox settings was changed from "Read Only" to **"Read/Write"** to grant the application permission to save the exported file, resolving a runtime crash.

---

## Task 4.1: Enhancements (Sorting, Searching, and CSV Export)

**Date:** November 23, 2025

### 1. Feature Overview

This sub-task enhances the existing Journal History window with advanced organizational and export capabilities, making it a more powerful tool for users to manage their data.

### 2. Key Functionalities to be Implemented

-   **Sorting Controls:** A UI control will be added to allow users to sort their journal entries by date, either "Newest First" (default) or "Oldest First".
-   **Search/Filter Bar:** A text field will be added to enable real-time searching. The list of entries will be filtered to show only those that contain the search query in either the original prompt text or the user's journal entry.
-   **CSV Export:** The export functionality will be expanded to support CSV (Comma-Separated Values) in addition to JSON. The export button will be converted into a menu to allow users to choose their desired format.

### 3. Architectural Considerations

-   The `HistoryView` will become more stateful, managing the sort order and search query.
-   The `JournalExporter` will be updated with new logic to handle CSV formatting, including proper escaping of special characters.
-   Computed properties or `.onChange` modifiers will be used to create a reactive list that responds to sorting and searching changes.

