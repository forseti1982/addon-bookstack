import Foundation

@MainActor
final class LogService: ObservableObject {
    @Published private(set) var entries: [LogEntry] = []

    func append(level: LogLevel = .info, _ message: String) {
        entries.append(LogEntry(timestamp: Date(), level: level, message: message))
    }

    func exportTranscript() -> String {
        let formatter = ISO8601DateFormatter()
        return entries
            .map { "[\(formatter.string(from: $0.timestamp))] [\($0.level.rawValue)] \($0.message)" }
            .joined(separator: "\n")
    }
}
