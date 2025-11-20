import Foundation

final class PromptEngine {

    private let repository: PromptRepository
    private let ratingsStore: RatingsStore.Type    // <-- important: use the type, not an instance
    private var ratings: [String: Int] = [:]
    private var lastPromptId: String?           // <-- add this

    init(repository: PromptRepository = PromptRepository(),
         ratingsStore: RatingsStore.Type = RatingsStore.self) {

        self.repository = repository
        self.ratingsStore = ratingsStore
        self.ratings = ratingsStore.load()   // <-- static
    }

    // MARK: - Public API

    func nextPrompt() -> Prompt? {
        let allowed = allowedTypes()
        let all = repository.allPrompts.filter { allowed.contains($0.type) }

        guard !all.isEmpty else {
            NSLog("[beKing] PromptEngine: no prompts available for selected types")
            return nil
        }

        // Avoid immediate repeat if we have more than 1 prompt
        let candidates: [Prompt]
        if let lastId = lastPromptId, all.count > 1 {
            let filtered = all.filter { $0.id != lastId }
            candidates = filtered.isEmpty ? all : filtered
        } else {
            candidates = all
        }

        // Compute weights for candidates
        let weights = candidates.map { weight(for: $0) }
        let totalWeight = weights.reduce(0, +)

        guard totalWeight > 0 else {
            // Fallback: if somehow all weights are zero, just pick random
            let picked = candidates.randomElement()
            lastPromptId = picked?.id
            return picked
        }

        // Weighted random draw
        let r = Double.random(in: 0..<totalWeight)
        var cumulative = 0.0

        for (index, prompt) in candidates.enumerated() {
            cumulative += weights[index]
            if r < cumulative {
                lastPromptId = prompt.id
                return prompt
            }
        }

        // Numerical edge-case fallback
        let picked = candidates.last
        lastPromptId = picked?.id
        return picked
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
    
    private func weight(for prompt: Prompt) -> Double {
        let rating = ratings[prompt.id] ?? 0
        let base = 1.0
        let step = 0.5   // how strongly each like/dislike moves the weight
        let w = base + Double(rating) * step
        return max(0.1, w)   // never let it reach 0 or negative
    }
    
    private func allowedTypes() -> Set<PromptType> {
        var result = Set<PromptType>()
        if UserDefaults.standard.bool(forKey: AppSettingsKeys.includeAffirmations) {
            result.insert(.affirmation)
        }
        if UserDefaults.standard.bool(forKey: AppSettingsKeys.includeJournalPrompts) {
            result.insert(.journal)
        }
        if UserDefaults.standard.bool(forKey: AppSettingsKeys.includeActionPrompts) {
            result.insert(.action)
        }
        return result
    }

}


