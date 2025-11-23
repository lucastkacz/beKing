import SwiftUI

fileprivate struct AlertInfo: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct HistoryView: View {
    enum SortOrder {
        case newestFirst, oldestFirst
    }

    // Source of truth
    @State private var allEntries: [JournalEntry] = []
    
    // UI State
    @State private var selectedEntry: JournalEntry?
    @State private var promptsById: [String: Prompt] = [:]
    @State private var alertInfo: AlertInfo?
    @State private var sortOrder: SortOrder = .newestFirst
    @State private var searchText: String = ""

    private var filteredAndSortedEntries: [JournalEntry] {
        // Filter first
        let filtered: [JournalEntry]
        if searchText.isEmpty {
            filtered = allEntries
        } else {
            filtered = allEntries.filter { entry in
                let promptText = promptsById[entry.promptId ?? ""]?.text ?? ""
                let entryText = entry.text
                
                return promptText.localizedCaseInsensitiveContains(searchText) ||
                       entryText.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Then sort
        switch sortOrder {
        case .newestFirst:
            return filtered.sorted { $0.date > $1.date }
        case .oldestFirst:
            return filtered.sorted { $0.date < $1.date }
        }
    }

    private let promptRepository: PromptRepository

    init(promptRepository: PromptRepository) {
        self.promptRepository = promptRepository
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HSplitView {
            // Master (List of Entries)
            List(selection: $selectedEntry) {
                ForEach(filteredAndSortedEntries) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.date, formatter: Self.dateFormatter)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if let promptText = promptsById[entry.promptId ?? ""]?.text {
                            Text(promptText)
                                .font(.subheadline)
                                .italic()
                                .lineLimit(1)
                        } else {
                            Text("Prompt ID: \(entry.promptId ?? "N/A")")
                                .font(.subheadline)
                                .italic()
                                .lineLimit(1)
                        }

                        Text(entry.text.prefix(100) + (entry.text.count > 100 ? "..." : ""))
                            .font(.body)
                    }
                    .tag(entry) // Required for selection in List
                }
            }
            .frame(minWidth: 200, idealWidth: 300)

            // Detail (Selected Entry)
            VStack(alignment: .leading, spacing: 10) {
                if let entry = selectedEntry {
                    Text(entry.date, formatter: Self.dateFormatter)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if let promptText = promptsById[entry.promptId ?? ""]?.text {
                        Text(promptText)
                            .font(.headline)
                            .italic()
                            .padding(.bottom, 5)
                    }

                    Text(entry.text)
                        .font(.body)
                        .textSelection(.enabled) // Allow copying text
                    Spacer()
                } else {
                    Text("Select an entry to view details")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .searchable(text: $searchText, prompt: "Search Journal")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Picker("Sort Order", selection: $sortOrder) {
                            Text("Newest First").tag(SortOrder.newestFirst)
                            Text("Oldest First").tag(SortOrder.oldestFirst)
                        }
                        .pickerStyle(.segmented)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button("Export to JSON...") { exportEntries(as: .json) }
                            Button("Export to CSV...") { exportEntries(as: .csv) }
                        } label: {
                            Text("Export")
                            Image(systemName: "square.and.arrow.up")
                        }
                        .disabled(filteredAndSortedEntries.isEmpty)
                    }
                }
                .frame(minWidth: 600, minHeight: 400)
                .onAppear(perform: loadData)
                .alert(item: $alertInfo) { info in
                    Alert(title: Text(info.title), message: Text(info.message), dismissButton: .default(Text("OK")))
                }
            }
        
            private func loadData() {
                allEntries = JournalStore.load()
                promptsById = promptRepository.allPrompts.reduce(into: [:]) { result, prompt in
                    result[prompt.id] = prompt
                }
                // Set selection after a brief delay to allow the sorted list to update
                DispatchQueue.main.async {
                    selectedEntry = filteredAndSortedEntries.first
                }
            }
        
            private enum ExportFormat { case json, csv }
            private func exportEntries(as format: ExportFormat) {
                do {
                    switch format {
                    case .json:
                        try JournalExporter.exportToJSON(entries: filteredAndSortedEntries)
                    case .csv:
                        try JournalExporter.exportToCSV(entries: filteredAndSortedEntries, prompts: promptsById)
                    }
                    alertInfo = AlertInfo(title: "Export Successful", message: "Your journal has been successfully exported as \(format).")
                } catch ExportError.panelCancelled {
                    // This is not a failure; the user simply chose not to save. Do nothing.
                    return
                } catch {
                    // This handles all other actual errors.
                    alertInfo = AlertInfo(title: "Export Failed", message: error.localizedDescription)
                }
            }
        }
        