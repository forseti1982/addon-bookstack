import Foundation

final class ECRTestEngine {
    func runVerification(for terminal: TerminalProfile, scenario: TestScenario) async -> [InterfaceTestResult] {
        scenario.interfaces.map { interface in
            let baseMessage = "\(interface.rawValue) gegen \(terminal.displayName)"

            if scenario.includeIntentionalError {
                return InterfaceTestResult(interface: interface, success: false, details: "\(baseMessage): Fehlerfall absichtlich ausgelöst")
            }

            if scenario.includeDeclineSimulation {
                return InterfaceTestResult(interface: interface, success: true, details: "\(baseMessage): Autorisierung als Ablehnung simuliert")
            }

            return InterfaceTestResult(interface: interface, success: true, details: "\(baseMessage): Test erfolgreich")
        }
    }
}
