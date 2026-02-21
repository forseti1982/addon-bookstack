import Foundation

@MainActor
final class TerminalStore: ObservableObject {
    @Published private(set) var terminals: [TerminalProfile] = []

    private let storageKey = "swipay.terminals.v1"
    private let maxTerminals = 5

    init() {
        load()
    }

    func add(_ terminal: TerminalProfile) {
        guard terminals.count < maxTerminals else { return }
        terminals.append(terminal)
        save()
    }

    func update(_ terminal: TerminalProfile) {
        guard let index = terminals.firstIndex(where: { $0.id == terminal.id }) else { return }
        terminals[index] = terminal
        save()
    }

    func remove(_ terminal: TerminalProfile) {
        terminals.removeAll { $0.id == terminal.id }
        save()
    }

    var canAddMore: Bool {
        terminals.count < maxTerminals
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(terminals) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([TerminalProfile].self, from: data) else {
            return
        }

        terminals = Array(decoded.prefix(maxTerminals))
    }
}
