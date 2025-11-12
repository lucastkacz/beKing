# beKing — Development Tasks

> Scope derived from BEKING.md v1.0 (menu-bar MVP → scheduler → journaling → action prompts).
> Convention: `[owner]` optional, estimate in **points** (1=trivial, 2=small, 3=medium, 5=large).

## Milestone v0.1.0 — Menu-bar foundation (target: 1–2 weeks)

### 1) Bootstrap app skeleton (SwiftUI + AppKit glue) — **2**

* **Tasks**

  * Create `beKingApp.swift` entry point, enable `LSUIElement=1` to hide Dock icon.
  * Add `MenuBarController.swift` that installs a status item (👑) with a minimal menu.
* **Acceptance**

  * App launches to menu-bar only; no Dock icon; menu shows “Show Prompt Now”, “Preferences…”, “Quit”.
* **Notes/Deps**

  * macOS 13+ target; SwiftUI lifecycle.

### 2) Resource bundling for prompts — **2**

* **Tasks**

  * Add `Resources/prompts.json` (seed with ~50 items; fields: `id`, `type`, `text`, `category`).
  * Write `Storage.swift` helpers to read bundled JSON and later write app-support files.
* **Acceptance**

  * “Show Prompt Now” pulls a random **Affirmation** from `prompts.json`.
* **Deps**

  * Task 1.

### 3) Prompt popup window (SwiftUI) — **3**

* **Tasks**

  * Build `PromptWindow.swift` (centered card, auto dark/light, Esc/⌘W dismiss, subtle appear animation).
  * Add 👍 / 👎 buttons (no persistence yet).
* **Acceptance**

  * Invoking “Show Prompt Now” opens the popup with an affirmation and rating buttons.
* **Deps**

  * Task 2.

### 4) Launch at login (SMAppService) — **3**

* **Tasks**

  * Implement `LaunchAtLogin.swift` with toggle persistence in `UserDefaults`.
  * Preferences stub with “Open at login” switch (non-functional UI okay; wire in next milestone).
* **Acceptance**

  * Toggling on persists; relaunch shows the service registered; verified via `SMAppService.mainApp`.
* **Deps**

  * Task 1.

### 5) Wake/login triggers (basic) — **3**

* **Tasks**

  * Implement `WakeListener.swift` subscribing to `NSWorkspace.didWakeNotification`.
  * At app launch and wake, auto-show one prompt (debounce within 60s of manual show).
* **Acceptance**

  * After sleep→wake or app launch, a prompt appears once (respects debounce).
* **Deps**

  * Task 3.

### 6) Ratings in memory (temporary) — **2**

* **Tasks**

  * Wire 👍/👎 to in-memory score map in `PromptEngine.swift` (no disk).
* **Acceptance**

  * Rating buttons don’t crash; log prints “rated {id}: +1 / −1”.
* **Deps**

  * Task 3.

---

## Milestone v0.2.0 — Scheduling + local storage + history

### 7) Persistent storage (App Support JSON) — **5**

* **Tasks**

  * Define file paths under `~/Library/Application Support/beKing/`.
  * Implement read/write for:

    * `ratings.json` → `{ [promptId: number] }`
    * `journal.json` → `{ id, promptId, dateISO, text }[]`
    * `settings` via `UserDefaults`/`@AppStorage`.
* **Acceptance**

  * After 👍/👎, `ratings.json` updates; reload app preserves scores.
* **Deps**

  * Task 6.

### 8) PromptEngine weight logic — **3**

* **Tasks**

  * Use ratings to bias selection (e.g., Epsilon-greedy 0.1; weight = base * (1 + 0.2*score)).
  * Respect disabled categories (future setting flag; default all enabled).
* **Acceptance**

  * Heavily liked prompts surface more often across sessions.
* **Deps**

  * Task 7.

### 9) Scheduler (intervals + weekday/time) — **5**

* **Tasks**

  * Implement `Scheduler.swift`: repeating `Timer` for X-hour intervals; calendar-based timers for specific weekday/time.
  * Single-instance guard and jitter (+/− 2 min) to avoid rigidity.
* **Acceptance**

  * If interval=4h, a prompt appears roughly every 4h while app is running.
  * If Mon 10:00 is set, prompt shows near that time when app is active.
* **Deps**

  * Task 5.

### 10) PreferencesView (functional) — **5**

* **Tasks**

  * SwiftUI tabbed preference window: Triggers, Categories, Appearance/Privacy, About.
  * Bind to `@AppStorage`: open-at-login, interval value, weekday/time pickers, category toggles, theme.
* **Acceptance**

  * Changing settings updates behavior without restart.
* **Deps**

  * Tasks 4, 9.

### 11) HistoryView (read-only) — **3**

* **Tasks**

  * List with columns: Date/Time, Prompt, Type, Rating, Note (first line).
  * Filters by type & date range; “Export CSV/JSON” (simple file save panel).
* **Acceptance**

  * Shows all prior prompt events; export produces valid CSV/JSON.
* **Deps**

  * Task 7.

### 12) Journal Task type — **5**

* **Tasks**

  * Add Journal UI: multiline text area + “Save note”.
  * Append entry to `journal.json` with timestamp; surface in History.
* **Acceptance**

  * Writing a note persists; appears in History.
* **Deps**

  * Tasks 3, 7, 11.

---

## Milestone v0.3.0 — Action prompts (mic/cam) + polish

### 13) Microphone capture for “Speak affirmation” — **5**

* **Tasks**

  * Request mic permission; record short clip (≤10s) with `AVAudioEngine` or `AVAudioRecorder`.
  * Playback; ephemeral file auto-delete unless user taps “Save…”.
* **Acceptance**

  * First use prompts for mic; subsequent uses record/playback successfully; temp file removed on close.
* **Deps**

  * Task 3.

### 14) Webcam capture for “Smile challenge” — **5**

* **Tasks**

  * Request camera permission; display live preview; capture still on “Snap”.
  * Save prompt-scoped temporary image; auto-delete unless “Save…”.
* **Acceptance**

  * First use prompts for camera; image captured and displayed; cleanup works.
* **Deps**

  * Task 3.

### 15) Category toggles (disable Action prompts) — **2**

* **Tasks**

  * In Preferences→Categories, checkbox to enable/disable “Action” type.
  * PromptEngine filters by enabled types.
* **Acceptance**

  * When “Action” disabled, only Affirmation/Journal shown.
* **Deps**

  * Tasks 8, 10, 13–14.

### 16) Export improvements & privacy copy — **2**

* **Tasks**

  * Export dialog default location (Desktop) and filename pattern.
  * Preferences→Privacy: show plain-language data policy; “Delete all data” button.
* **Acceptance**

  * One-click wipe removes ratings/journal/media; app continues to function.
* **Deps**

  * Task 7, 11, 12.

---

## Milestone v0.4.0 — Online prompt source (optional)

### 17) Remote prompt fetch (fallback to local) — **5**

* **Tasks**

  * Add `PromptSource` abstraction with local JSON provider and optional HTTP provider.
  * On failure/timeouts, use bundled `prompts.json`; cache last successful remote snapshot.
* **Acceptance**

  * With network disabled, app still serves prompts; with network, remote list merges/dedupes by `id`.
* **Deps**

  * Task 2.
