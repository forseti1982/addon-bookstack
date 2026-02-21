import Foundation

final class PortTestService {
    /// Standard-Ziele laut gewünschter TCP/IP-Liste als Startkonfiguration.
    /// Werte können in der App erweitert/angepasst werden.
    func defaultTargets(for terminal: TerminalProfile?) -> [PortTestTarget] {
        var targets: [PortTestTarget] = [
            PortTestTarget(title: "Acquirer Gateway", host: "198.51.100.10", port: 443, type: .externalSystem),
            PortTestTarget(title: "Cloud KIT Endpoint", host: "api.paytec.example", port: 443, type: .externalSystem),
            PortTestTarget(title: "REST API", host: "rest.paytec.example", port: 8443, type: .externalSystem)
        ]

        if let terminal {
            targets.append(
                PortTestTarget(
                    title: terminal.displayName,
                    host: terminal.ipAddress,
                    port: terminal.port,
                    type: .terminal
                )
            )
        }

        return targets
    }

    func run(target: PortTestTarget) async -> String {
        // Platzhalter für echte TCP-Connect Prüfung (NWConnection)
        return "\(target.host):\(target.port) erreichbar (simuliert)"
    }
}
