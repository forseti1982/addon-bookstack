import Foundation

struct DiscoveredTerminal: Identifiable {
    let id = UUID()
    let suggestedName: String
    let suggestedMac: String
    let ipAddress: String
    let port: Int
}

final class TerminalScanner {
    /// Beispiel-OUI Präfixe. Diese Liste sollte gemäss interner Confluence-Pflege aktualisiert werden.
    private let knownNexgoPrefixes = ["84:73:03", "A4:9B:4F", "D8:96:95"]

    func discoverPossibleNexgoTerminals() async -> [DiscoveredTerminal] {
        // iOS liefert keine direkte ARP/MAC-Tabelle. Daher wird hier mit bekannten Mustern gearbeitet.
        // In der Produktion kann dies über MDM/Companion-Service ergänzt werden.
        let mockedHosts = [
            ("NEXGO-N86", "84:73:03:11:AB:01", "192.168.1.41", 20107),
            ("NEXGO-N96", "A4:9B:4F:C0:DE:02", "192.168.1.45", 20007)
        ]

        return mockedHosts
            .filter { host in
                knownNexgoPrefixes.contains { host.1.uppercased().hasPrefix($0) }
            }
            .map {
                DiscoveredTerminal(
                    suggestedName: $0.0,
                    suggestedMac: $0.1,
                    ipAddress: $0.2,
                    port: $0.3
                )
            }
    }
}
