import SwiftUI

struct PortDiagnosticsView: View {
    @EnvironmentObject private var store: TerminalStore
    @EnvironmentObject private var logService: LogService

    @State private var selectedTerminal: TerminalProfile?
    @State private var results: [String] = []

    private let service = PortTestService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("Terminal", selection: $selectedTerminal) {
                    Text("Keines").tag(nil as TerminalProfile?)
                    ForEach(store.terminals) { terminal in
                        Text(terminal.displayName).tag(terminal as TerminalProfile?)
                    }
                }
                .pickerStyle(.menu)

                Button("Porttests starten") {
                    Task {
                        results.removeAll()
                        for target in service.defaultTargets(for: selectedTerminal) {
                            let result = await service.run(target: target)
                            results.append("\(target.type.rawValue): \(result)")
                            logService.append("Porttest: \(result)")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)

                List(results, id: \.self) { result in
                    Text(result)
                }
            }
            .padding()
            .navigationTitle("Porttest")
        }
    }
}
