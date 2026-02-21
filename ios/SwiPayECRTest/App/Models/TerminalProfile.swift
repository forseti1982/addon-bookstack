import Foundation

enum TerminalInterface: String, CaseIterable, Codable, Identifiable {
    case jsonKit = "JSON KIT"
    case zvt = "ZVT"
    case opi = "OPI"
    case cloudKit = "Cloud KIT"
    case restAPI = "REST API"

    var id: String { rawValue }
}

struct TerminalProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var displayName: String
    var macAddress: String
    var ipAddress: String
    var port: Int
    var preferredInterface: TerminalInterface

    init(
        id: UUID = UUID(),
        displayName: String,
        macAddress: String,
        ipAddress: String,
        port: Int,
        preferredInterface: TerminalInterface
    ) {
        self.id = id
        self.displayName = displayName
        self.macAddress = macAddress
        self.ipAddress = ipAddress
        self.port = port
        self.preferredInterface = preferredInterface
    }
}

struct TestScenario: Identifiable {
    let id = UUID()
    let includeIntentionalError: Bool
    let includeDeclineSimulation: Bool
    let interfaces: [TerminalInterface]
}
