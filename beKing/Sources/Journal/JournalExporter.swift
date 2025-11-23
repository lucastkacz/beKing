import Cocoa

enum ExportError: Error, LocalizedError {
    case encodingFailed(Error)
    case panelCancelled
    case writeFailed(Error)
    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode journal entries."
        case .panelCancelled:
            return "Export operation was cancelled."
        case .writeFailed:
            return "Failed to write the export file to disk."
        }
    }
}

struct JournalExporter {
    // MARK: - Public API
    
    /// Exports journal entries to a JSON file, presenting a save panel to the user.
    static func exportToJSON(entries: [JournalEntry]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        encoder.dateEncodingStrategy = .iso8601
        let data: Data
        do {
            data = try encoder.encode(entries)
        } catch {
            throw ExportError.encodingFailed(error)
        }
        try saveData(data, format: .json)
    }

    /// Exports journal entries to a CSV file, presenting a save panel to the user.
    static func exportToCSV(entries: [JournalEntry], prompts: [String: Prompt]) throws {
        let csvString = createCSV(from: entries, prompts: prompts)
        guard let data = csvString.data(using: .utf8) else {
            // This is a simplified error; a more specific one could be added
            throw ExportError.encodingFailed(NSError(domain: "beKing", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to encode CSV string to UTF-8 data."]))
        }
        try saveData(data, format: .csv)
    }

    // MARK: - Private Helpers

    private enum ExportFormat {
        case json, csv
    }

    private static func saveData(_ data: Data, format: ExportFormat) throws {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        switch format {
        case .json:
            savePanel.nameFieldStringValue = "beKing_Journal_\(dateString).json"
            savePanel.title = "Export Journal to JSON"
        case .csv:
            savePanel.nameFieldStringValue = "beKing_Journal_\(dateString).csv"
            savePanel.title = "Export Journal to CSV"
        }

        let response = savePanel.runModal()
        guard response == .OK, let url = savePanel.url else {
            throw ExportError.panelCancelled
        }
        do {
            try data.write(to: url)
        } catch {
            throw ExportError.writeFailed(error)
        }
    }
    
    private static func createCSV(from entries: [JournalEntry], prompts: [String: Prompt]) -> String {
        var csv = "date,prompt,entry\n"
        let dateFormatter = ISO8601DateFormatter()

        for entry in entries {
            let date = dateFormatter.string(from: entry.date)
            let promptText = prompts[entry.promptId ?? ""]?.text ?? "N/A"
            let entryText = entry.text

            let row = [
                escapeCSVField(date),
                escapeCSVField(promptText),
                escapeCSVField(entryText)
            ].joined(separator: ",")
            
            csv.append(row + "\n")
        }
        return csv
    }

    private static func escapeCSVField(_ field: String) -> String {
        let needsQuotes = field.contains(",") || field.contains("\"") || field.contains("\n")
        if !needsQuotes {
            return field
        }
        let escapedField = field.replacing("\"", with: "\"\"")
        return "\"\(escapedField)\""
    }
}
