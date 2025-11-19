import Foundation

final class PromptRepository {

    private(set) var allPrompts: [Prompt] = []

    init() {
        loadPrompts()
    }

    private func loadPrompts() {
        guard let url = Bundle.main.url(forResource: "prompts", withExtension: "json") else {
            NSLog("[beKing] ERROR: prompts.json not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let prompts = try JSONDecoder().decode([Prompt].self, from: data)
            self.allPrompts = prompts
            NSLog("[beKing] Loaded \(prompts.count) prompts")
        } catch {
            NSLog("[beKing] ERROR loading prompts.json: \(error)")
        }
    }
}
