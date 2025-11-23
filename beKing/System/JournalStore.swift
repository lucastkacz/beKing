import Foundation

struct JournalEntry: Codable, Identifiable, Hashable {
    let id: UUID
    let promptId: String?
    let date: Date
    let text: String

    init(id: UUID = UUID(), promptId: String?, date: Date = Date(), text: String) {
        self.id = id
        self.promptId = promptId
        self.date = date
        self.text = text
    }
}

/// Manages journal entries persisted to journal.json.
struct JournalStore {
    private static let filename = "journal.json"

    typealias Entries = [JournalEntry]

    /// Load all entries; returns empty array if file doesn't exist or fails.
    static func load() -> Entries {
        do {
            return try Storage.readJSON(Entries.self, from: filename, default: [])
        } catch {
            NSLog("[beKing] JournalStore.load error: \(error)")
            return []
        }
    }

    /// Save entries to disk, overwriting the file.
    static func save(_ entries: Entries) {
        do {
            try Storage.writeJSON(entries, to: filename)
        } catch {
            NSLog("[beKing] JournalStore.save error: \(error)")
        }
    }

    /// Append a single entry and persist.
    static func append(_ entry: JournalEntry) {
        var current = load()
        current.append(entry)
        save(current)
    }
}
