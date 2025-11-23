# Task 3: Prompt Engine & Interaction

This task focused on building the "brain" of the application—the `PromptEngine`—and implementing the core user interactions for rating prompts and saving journal entries.

### 1. Feature Overview

The primary goal was to move from showing placeholder content to displaying real, intelligently selected prompts and to make the prompt window fully interactive.

### 2. Key Functionalities

-   **Weighted Prompt Selection:** The `PromptEngine` was created to select the next prompt to display. It uses a weighted random algorithm where prompts that the user "likes" are shown more often, and "disliked" prompts are shown less often.
-   **Category Filtering:** The engine respects the user's choices in Preferences, filtering out disabled prompt categories (e.g., Affirmations, Journal Prompts) before making a selection.
-   **Rating Persistence:** The "Like" (👍) and "Dislike" (👎) buttons in the prompt window are now fully functional. Clicking them adjusts the prompt's score, and the new ratings are immediately saved to `ratings.json` via the `RatingsStore`.
-   **Inline Journaling:** The prompt window now dynamically shows a multi-line `TextEditor` for prompts of type `.journal`. When the user types an entry and clicks "Save," the entry is persisted to `journal.json` via the `JournalStore`.
-   **Prompt Loading:** A `PromptRepository` was created to load the initial set of prompts from the `prompts.json` file included in the app's resource bundle.

### 3. File Changes

#### New Files Created

-   `Sources/Prompts/PromptEngine.swift`: The core class containing the prompt selection and rating logic.
-   `Sources/Prompts/PromptRepository.swift`: Handles the loading of prompts from the bundled JSON file.
-   `Sources/Prompts/Prompt.swift`: The `Codable` data model for a single prompt.
-   `Sources/Prompts/PromptType.swift`: An `enum` defining the different types of prompts.

#### Existing Files Modified

-   `PromptWindow.swift`: Significantly enhanced to be data-driven. It now displays dynamic content from a `Prompt` object and includes interactive buttons and a text editor for journaling.
-   `PromptWindowHost.swift`: Updated to instantiate and use the `PromptEngine`. It now fetches the next prompt and implements the logic for the `onLike`, `onDislike`, and `onSaveJournal` closures that are passed to the `PromptWindow`.
-   `System/RatingStore.swift` & `System/JournalStore.swift`: While created in Task 2, these files are now actively used by the `PromptEngine` and `PromptWindowHost` to persist user interactions.

### 4. Architectural Decisions & Notes

-   **Encapsulation of Logic:** The complex logic for prompt selection and weighting was properly encapsulated within the `PromptEngine`, keeping it isolated from the UI and other services.
-   **Decoupled UI:** The `PromptWindow` (the view) was decoupled from the business logic by using action closures (e.g., `onLike`). The view's only job is to display data and report that a button was tapped; the `PromptWindowHost` decides *what* to do in response.
-   **Architectural Note:** In the current implementation, a new `PromptEngine` is created inside `PromptWindowHost`. A potential future improvement would be to refactor this so that a single, long-lived `PromptEngine` instance is created and managed by the `AppDelegate`, which would improve state consistency.
