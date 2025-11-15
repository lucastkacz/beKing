import Foundation
import UniformTypeIdentifiers

enum StorageError: Error {
    case appSupportDirectoryCreationFailed(underlying: Error)
    case writeFailed(url: URL, underlying: Error)
    case readFailed(url: URL, underlying: Error)
    case decodeFailed(url: URL, underlying: Error)
}

struct Storage {
    // MARK: - Public API

    /// Returns the base folder: ~/Library/Application Support/beKing
    static func appSupportDirectory() throws -> URL {
        let fm = FileManager.default
        guard let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            // Extremely rare; FileManager should always return something here
            throw StorageError.appSupportDirectoryCreationFailed(underlying: NSError(domain: "beKing", code: -1))
        }
        let dir = base.appendingPathComponent("beKing", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            do {
                try fm.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw StorageError.appSupportDirectoryCreationFailed(underlying: error)
            }
        }
        return dir
    }

    /// Convenience: build a file URL under app support for a given filename.
    static func fileURL(_ filename: String) throws -> URL {
        try appSupportDirectory().appendingPathComponent(filename, conformingTo: .json)
    }

    /// Write any Encodable value as pretty JSON, atomically.
    static func writeJSON<T: Encodable>(_ value: T, to filename: String) throws {
        let url = try fileURL(filename)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        do {
            let data = try encoder.encode(value)
            try data.write(to: url, options: [.atomic])
        } catch {
            throw StorageError.writeFailed(url: url, underlying: error)
        }
    }

    /// Read and decode a JSON file. If it doesn’t exist, returns `defaultValue`.
    static func readJSON<T: Decodable>(_ type: T.Type, from filename: String, default defaultValue: @autoclosure () -> T) throws -> T {
        let url = try fileURL(filename)
        let fm = FileManager.default
        guard fm.fileExists(atPath: url.path) else {
            return defaultValue()
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw StorageError.decodeFailed(url: url, underlying: error)
        } catch {
            throw StorageError.readFailed(url: url, underlying: error)
        }
    }
}
