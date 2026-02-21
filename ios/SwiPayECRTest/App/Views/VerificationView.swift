import SwiftUI

struct VerificationView: View {
    @EnvironmentObject private var store: TerminalStore
    @EnvironmentObject private var logService: LogService

    @State private var selectedTerminalID: UUID?
    @State private var includeError = false
    @State private var includeDecline = false
    @State private var results: [InterfaceTestResult] = []

    private let engine = ECRTestEngine()

    var body: some View {
        NavigationStack {
            Form {
                Picker("Terminal", selection: $selectedTerminalID) {
                    Text("Bitte wählen").tag(nil as UUID?)
                    ForEach(store.terminals) { terminal in
                        Text(terminal.displayName).tag(Optional(terminal.id))
                    }
                }

                Toggle("Absichtlichen Fehler mitsenden", isOn: $includeError)
                Toggle("Ablehnung simulieren", isOn: $includeDecline)

                Button("Verifizierungen starten (EP2)") {
                    Task {
                        guard let terminal = store.terminals.first(where: { $0.id == selectedTerminalID }) else {
                            return
                        }

                        let scenario = TestScenario(
                            includeIntentionalError: includeError,
                            includeDeclineSimulation: includeDecline,
                            interfaces: TerminalInterface.allCases
                        )

                        results = await engine.runVerification(for: terminal, scenario: scenario)
                        logService.append("EP2 Verifizierung abgeschlossen für \(terminal.displayName)")
                        results.forEach { logService.append($0.success ? .info : .warning, $0.details) }
                    }
                }
                .buttonStyle(.borderedProminent)

                Section("Ergebnisse") {
                    ForEach(results) { item in
                        Label(item.details, systemImage: item.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(item.success ? .green : .orange)
                    }
                }
            }
            .navigationTitle("Verifizierung")
        }
    }
}
