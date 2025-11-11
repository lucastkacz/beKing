## 📘 **BEKING.md — Final Master Specification (v1.0)**

### 1. product overview

**beKing** is a lightweight macOS application that delivers automated or scheduled self-improvement prompts.
It periodically presents affirmations, journaling tasks, or small action exercises (e.g., speak an affirmation aloud, smile for a quick selfie).
Triggers can be automatic (login, wake, interval, weekday/time) or manual via the menu-bar 👑 icon.

**Mission:** help users build positive habits—motivation, confidence, mindfulness—through spontaneous, context-aware micro-interactions.

---

### 2. target audience

Individuals interested in **self-improvement, reflection, and motivation** who want small positive nudges throughout the day without friction.
Designed for people who appreciate automation and minimal configuration.

---

### 3. high-level behavior

| Situation                                   | Behavior                                                                       |
| ------------------------------------------- | ------------------------------------------------------------------------------ |
| **Login / Wake**                            | show a random prompt automatically (default).                                  |
| **Scheduled interval or specific day/time** | show according to user preference (e.g., every 4 h, Mondays 10 am).            |
| **Manual trigger**                          | user clicks 👑 menu-bar icon → “Show Prompt Now”.                              |
| **Prompt completion**                       | user may like/dislike and, if journaling, type a note.                         |
| **History access**                          | from menu-bar → “History…” lists all previous prompts + ratings + notes.       |
| **Settings**                                | from menu-bar → “Preferences…” (triggers, categories, theme, privacy, export). |

---

### 4. prompt types

1. **Affirmation** – motivational sentence or quote.
2. **Journal Task** – prompt + text box to capture reflection.
3. **Action Task** – interactive activity:

   * *Speak affirmation aloud* → record & playback.
   * *Smile challenge* → photo capture (if webcam available).

Prompt schema:

```json
{
  "id": "uuid",
  "type": "affirmation | journal | action",
  "text": "string",
  "tags": ["confidence","gratitude"],
  "weight": 3
}
```

---

### 5. user features (mvp)

* Menu-bar only app (no Dock icon).
* Default triggers: login + wake.
* Configurable schedules (intervals, weekdays, times).
* Like / dislike system (local weight adjustment).
* Local journaling storage + “History” view.
* Export journal entries to JSON or CSV.
* Optional categories (users can disable Action prompts).
* Online prompt database (future fetch); local bundle fallback.
* Preferences window:

  * trigger configuration,
  * category toggles,
  * open-at-login toggle,
  * theme (dark/light),
  * privacy/export controls.
* Menu-bar icon 👑 with quick actions.
* App Sandbox + permissions handling.

---

### 6. data storage

| Item                    | Location                                                              | Format                    |
| ----------------------- | --------------------------------------------------------------------- | ------------------------- |
| **Prompts**             | local `prompts.json`, optional remote sync                            | array of prompt objects   |
| **Ratings**             | `~/Library/Application Support/beKing/ratings.json`                   | `{promptId: score}`       |
| **Journal Entries**     | `~/Library/Application Support/beKing/journal.json`                   | `{id,promptId,date,text}` |
| **Settings**            | `UserDefaults` / `AppStorage`                                         | key-value                 |
| **Media (audio/photo)** | same folder, temporary, auto-deleted after playback unless user saves |                           |

---

### 7. system integration

* **Triggers:**

  * Login → `SMAppService` login item.
  * Wake → `NSWorkspace.didWakeNotification`.
  * Timed schedule → background `Timer`.
* **Permissions:** microphone & camera requested on first use only.
* **Appearance:** SwiftUI dark/light adaptive; subtle accent color.
* **Privacy:** all data local; nothing leaves the device unless user exports.

---

### 8. architecture overview

```
App/
  beKingApp.swift          // entry point
  MenuBarController.swift  // creates status item
Features/
  PromptEngine.swift       // selects next prompt; manages weights
  PromptWindow.swift       // SwiftUI popup view
  PreferencesView.swift
  HistoryView.swift
System/
  LaunchAtLogin.swift
  WakeListener.swift
  Scheduler.swift          // manages user intervals
  Storage.swift            // handles JSON read/write
Resources/
  prompts.json
```

---

### 9. history view

Displays chronological log with filters:

| Column                                                | Description                    |
| ----------------------------------------------------- | ------------------------------ |
| Date / Time                                           | when prompt appeared           |
| Prompt Text                                           | truncated if long              |
| Type                                                  | affirmation / journal / action |
| Rating                                                | 👍 / 👎                        |
| Note                                                  | first line preview             |
| Buttons: *Export CSV*, *Export JSON*, *Delete Entry*. |                                |

---

### 10. future roadmap

| Milestone   | Key deliverables                                                   |
| ----------- | ------------------------------------------------------------------ |
| **v0.1.0**  | Menu-bar foundation, local random affirmations, basic preferences. |
| **v0.2.0**  | Scheduling system, journaling storage, like/dislike.               |
| **v0.3.0**  | Remote prompt fetch, action prompts (record/photo).                |
| **v0.4.0+** | Cloud sync, statistics dashboard, custom prompts, themes.          |

---

### 11. decisions log

| Decision                 | Reason                      | Consequence                |
| ------------------------ | --------------------------- | -------------------------- |
| SwiftUI + limited AppKit | native, clean UI            | macOS 13+                  |
| LSUIElement = 1          | hide Dock icon              | Settings only via menu-bar |
| JSON local storage       | simple, portable            | easy future migration      |
| SMAppService login item  | modern, sandbox-safe        | macOS 13+ dependency       |
| Optional Action prompts  | privacy + hardware variance | user can disable category  |
| Local privacy model      | trust & simplicity          | export opt-in only         |

---

### 12. open questions

* Remote database hosting: GitHub raw / Firebase / custom API?
* Weight learning: local only or future global sync?
* Notifications / sounds for prompt arrival?
* Accessibility + localization (multi-language) scope?

---

### 13. privacy statement (draft)

All user data—journal entries, audio, photos, ratings—remain on the device.
No external transmission occurs without explicit user export or future opt-in cloud sync.
Audio/photo captures used only for real-time playback, deleted afterward by default.

---

### 14. design notes

* Minimal, calm aesthetic; centered prompt text; soft animation on open.
* Short duration window; dismissible via ⌘W or Esc.
* Optional chime when prompt appears.
* Dark/light theme auto-follows macOS preference.

---

### 15. version control

* `main` branch for stable builds.
* Feature branches per milestone (`feat/menu-bar`, `feat/scheduler`, etc.).
* Semantic versioning (`v0.1.0`, `v0.2.0`, …).

---

### 16. summary

beKing blends automation and self-improvement into a non-intrusive macOS companion.
It balances minimal UI with meaningful functionality: smart scheduling, local privacy, and personalized positivity.

---

that’s a full, ready-to-commit `BEKING.md`.
it’s detailed enough for anyone to build the app, yet simple to maintain as your single source of truth.

---

**final optional clarifications before freezing v1.0**

1. do you want built-in **notification center reminders** (instead of or alongside pop-up windows)?
2. any **minimum macOS version** preference (13 Ventura or newer)?
3. should exported CSV/JSON files be saved to a specific folder (e.g., Desktop) or user-selectable?

once you confirm those, i’ll finalize the file for copy-paste with consistent markdown formatting.

