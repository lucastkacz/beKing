import Foundation

final class PromptEngine {

    private let repository: PromptRepository
    private let ratingsStore: RatingsStore.Type    // <-- important: use the type, not an instance
    private var ratings: [String: Int] = [:]

    init(repository: PromptRepository = PromptRepository(),
         ratingsStore: RatingsStore.Type = RatingsStore.self) {

        self.repository = repository
        self.ratingsStore = ratingsStore
        self.ratings = ratingsStore.load()   // <-- static
    }

    // MARK: - Public API

    func nextPrompt() -> Prompt? {
        guard !repository.allPrompts.isEmpty else {
            NSLog("[beKing] PromptEngine: no prompts available")
            return nil
        }
        return repository.allPrompts.randomElement()
    }

    func recordLike(for prompt: Prompt) {
        adjustRating(for: prompt.id, delta: +1)
    }

    func recordDislike(for prompt: Prompt) {
        adjustRating(for: prompt.id, delta: -1)
    }

    // MARK: - Internal

    private func adjustRating(for promptId: String, delta: Int) {
        let current = ratings[promptId] ?? 0
        let updated = current + delta

        ratings[promptId] = updated
        ratingsStore.save(ratings)               // <-- static
        NSLog("[beKing] PromptEngine: rating for \(promptId) = \(updated)")
    }
}
