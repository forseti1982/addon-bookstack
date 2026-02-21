import SwiftUI

struct TerminalListView: View {
    @EnvironmentObject private var store: TerminalStore
    @EnvironmentObject private var logService: LogService

    @State private var discovered: [DiscoveredTerminal] = []
    @State private var scannerBusy = false

    private let scanner = TerminalScanner()

    var body: some View {
        NavigationStack {
            List {
                Section("Gespeicherte Terminals (max. 5)") {
                    ForEach(store.terminals) { terminal in
                        NavigationLink {
                            TerminalEditorView(mode: .edit(terminal))
                        } label: {
                            VStack(alignment: .leading) {
                                Text(terminal.displayName).font(.headline)
                                Text("\(terminal.ipAddress):\(terminal.port) • \(terminal.preferredInterface.rawValue)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.map { store.terminals[$0] }.forEach(store.remove)
                    }
                }

                Section("Nexgo Suche") {
                    Button(scannerBusy ? "Suche läuft..." : "Mögliche Nexgo MACs finden") {
                        Task {
                            scannerBusy = true
                            discovered = await scanner.discoverPossibleNexgoTerminals()
                            scannerBusy = false
                            logService.append("Netzwerksuche abgeschlossen: \(discovered.count) Treffer")
                        }
                    }
                    .disabled(scannerBusy)

                    ForEach(discovered) { item in
                        NavigationLink {
                            TerminalEditorView(
                                mode: .create(
                                    TerminalProfile(
                                        displayName: item.suggestedName,
                                        macAddress: item.suggestedMac,
                                        ipAddress: item.ipAddress,
                                        port: item.port,
                                        preferredInterface: .jsonKit
                                    )
                                )
                            )
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.suggestedName)
                                Text("MAC: \(item.suggestedMac) • \(item.ipAddress):\(item.port)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("SwiPay | ECR Test")
            .toolbar {
                NavigationLink("Neu") {
                    TerminalEditorView(
                        mode: .create(
                            TerminalProfile(
                                displayName: "Neues Terminal",
                                macAddress: "",
                                ipAddress: "192.168.1.",
                                port: 20107,
                                preferredInterface: .jsonKit
                            )
                        )
                    )
                }
                .disabled(!store.canAddMore)
            }
        }
    }
}
