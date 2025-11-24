# Task 5: Action Prompts (Mic & Camera)

**Date Started:** November 23, 2025

### 1. Feature Overview

This task focuses on implementing the interactive "Action" prompt types, which require access to the user's microphone and camera. This will add a new dimension of interactivity to the application.

### 2. Key Functionalities to be Implemented

-   **Microphone Permission:**
    -   Properly request microphone access from the user with a clear explanation.
    -   Handle the case where permission is denied.
-   **Audio Recording & Playback:**
    -   For "Speak affirmation" prompts, provide UI to start and stop a short audio recording.
    -   After recording, allow the user to play back their recording.
    -   Recordings will be stored as temporary files and deleted after the prompt window is closed, unless explicitly saved by the user (a post-V1 feature).
-   **Camera Permission & Capture:**
    -   Properly request camera access from the user.
    -   For "Smile challenge" prompts, display a live camera preview.
    -   Provide a button to capture a still image.
-   **Dynamic Prompt UI:**
    -   The `PromptWindow` will be updated to show the correct UI controls based on the specific action prompt type.

### 3. Architectural Considerations

-   A `PermissionsManager` will be created to handle the logic for checking and requesting system permissions.
-   An `AudioEngine` or similar service will be created to encapsulate the complexities of `AVFoundation` for recording and playback.
-   The `PromptWindow` view will become more stateful to manage the different UI states (e.g., ready, recording, playback).
-   The `Info.plist` file must be updated with usage descriptions for both the microphone (`NSMicrophoneUsageDescription`) and camera (`NSCameraUsageDescription`).

### 4. Potential Enhancements (Post-V1)

- **Real-time Audio Waveform:** For a better user experience during recording, a real-time visualization of the audio waveform (similar to a voice note) could be displayed. This would involve more complex audio buffer analysis and custom drawing in SwiftUI.

