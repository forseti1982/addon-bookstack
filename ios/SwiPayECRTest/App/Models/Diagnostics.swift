import Foundation

enum PortTestTargetType: String, CaseIterable, Identifiable {
    case terminal = "Lokales Terminal"
    case externalSystem = "Externes System"

    var id: String { rawValue }
}

struct PortTestTarget: Identifiable {
    let id = UUID()
    let title: String
    let host: String
    let port: Int
    let type: PortTestTargetType
}

enum LogLevel: String {
    case info = "INFO"
    case warning = "WARN"
    case error = "ERROR"
}

struct LogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let level: LogLevel
    let message: String
}

struct InterfaceTestResult: Identifiable {
    let id = UUID()
    let interface: TerminalInterface
    let success: Bool
    let details: String
}
