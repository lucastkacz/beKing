# Task 5: Action Prompts (Mic & Camera)

**Date Completed:** November 23, 2025

### 1. Feature Overview

This task implemented the interactive "Action" prompt types, which required access to the user's microphone and camera. This added a new dimension of interactivity to the application, allowing for prompts like "Speak affirmation" and "Smile challenge".

### 2. Key Functionalities

-   **Microphone Workflow:**
    -   Successfully implemented runtime permission requests for microphone access using `AVCaptureDevice`.
    -   The UI now supports a full record/stop/playback flow for audio clips.
    -   Recordings are saved to a temporary `.caf` file via `AVAudioEngine` and are discarded when the app is closed.
-   **Camera Workflow:**
    -   Implemented runtime permission requests for camera access.
    -   A live camera preview is displayed within the prompt window for relevant prompts using `AVCaptureSession`.
    -   A full capture/review/retake flow was created. Captured images are held in memory temporarily for review and are not saved to disk, per the project specification.
-   **Dynamic Prompt UI:**
    -   The `ActionPromptView` was created to dynamically show the correct UI (microphone or camera controls) based on keywords in the prompt's text.
-   **Sandbox Integration:**
    -   The project was correctly configured with the necessary App Sandbox entitlements ("Audio Input", "Camera") and `Info.plist` usage descriptions to allow hardware access.

### 3. File Changes

#### New Files Created

-   `beKing/Sources/Actions/AudioService.swift`: An `ObservableObject` that encapsulates all logic for microphone permissions, recording, and playback.
-   `beKing/Sources/Actions/CameraService.swift`: An `ObservableObject` that manages camera permissions, the `AVCaptureSession`, and photo capture.
-   `beKing/Sources/Actions/ActionPromptView.swift`: A dedicated SwiftUI view to handle the complex UI states for both microphone and camera interactions.
-   `beKing/Sources/Actions/CameraPreviewView.swift`: An `NSViewRepresentable` wrapper to display the live `AVCaptureSession` preview in SwiftUI.

#### Existing Files Modified

-   `beKing/PromptWindowHost.swift`: Updated to create and own instances of the new `AudioService` and `CameraService`.
-   `beKing/PromptWindow.swift`: Updated to accept and pass the new services down to the `ActionPromptView`.
-   `Info.plist` & `beKing.xcodeproj`: Updated by the user to include the necessary hardware usage descriptions and App Sandbox entitlements.

### 4. Architectural Decisions & Notes

-   **Dedicated Services:** All complex `AVFoundation` logic was encapsulated in dedicated, `ObservableObject`-conforming services (`AudioService`, `CameraService`), separating low-level hardware interaction from the UI.
-   **Specialized View:** A dedicated `ActionPromptView` was created to handle the multiple states of these complex prompts, preventing the main `PromptWindow` from becoming overly complicated.
-   **Platform-Specific APIs:** The implementation required careful use of macOS-specific APIs (e.g., `AVCaptureDevice` for permissions) after initial attempts with incorrect, iOS-only APIs (`AVAudioSession`) failed. This was a key learning and debugging experience.

### 5. Potential Enhancements (Post-V1)

- **Real-time Audio Waveform:** For a better user experience during recording, a real-time visualization of the audio waveform could be displayed.