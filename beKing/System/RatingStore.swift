import Foundation

/// Manages like/dislike scores per prompt ID, persisted to ratings.json.
struct RatingsStore {
    private static let filename = "ratings.json"

    typealias Ratings = [String: Int]   // promptId -> score

    static func load() -> Ratings {
        do {
            return try Storage.readJSON(Ratings.self, from: filename, default: [:])
        } catch {
            NSLog("[beKing] RatingsStore.load error: \(error)")
            return [:]
        }
    }

    static func save(_ ratings: Ratings) {
        do {
            try Storage.writeJSON(ratings, to: filename)
        } catch {
            NSLog("[beKing] RatingsStore.save error: \(error)")
        }
    }
}
