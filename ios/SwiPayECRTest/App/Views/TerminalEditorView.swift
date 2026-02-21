import SwiftUI

struct TerminalEditorView: View {
    enum Mode {
        case create(TerminalProfile)
        case edit(TerminalProfile)
    }

    @EnvironmentObject private var store: TerminalStore
    @EnvironmentObject private var logService: LogService
    @Environment(\.dismiss) private var dismiss

    @State private var draft: TerminalProfile
    private let existing: Bool

    init(mode: Mode) {
        switch mode {
        case .create(let terminal):
            _draft = State(initialValue: terminal)
            existing = false
        case .edit(let terminal):
            _draft = State(initialValue: terminal)
            existing = true
        }
    }

    var body: some View {
        Form {
            TextField("Name", text: $draft.displayName)
            TextField("MAC", text: $draft.macAddress)
            TextField("IP", text: $draft.ipAddress)
            Stepper("Port: \(draft.port)", value: $draft.port, in: 1...65535)

            Picker("Schnittstelle", selection: $draft.preferredInterface) {
                ForEach(TerminalInterface.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Button(existing ? "Speichern" : "Hinzufügen") {
                if existing {
                    store.update(draft)
                    logService.append("Terminal aktualisiert: \(draft.displayName)")
                } else {
                    store.add(draft)
                    logService.append("Terminal hinzugefügt: \(draft.displayName)")
                }
                dismiss()
            }
        }
        .navigationTitle(existing ? "Terminal bearbeiten" : "Terminal hinzufügen")
    }
}
