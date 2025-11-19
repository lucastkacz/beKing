import Foundation

struct Prompt: Identifiable, Codable {
    let id: String
    let type: PromptType
    let text: String
    let tags: [String]?
}
