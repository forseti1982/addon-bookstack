import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TerminalListView()
                .tabItem {
                    Label("Terminals", systemImage: "creditcard")
                }

            PortDiagnosticsView()
                .tabItem {
                    Label("Porttest", systemImage: "network")
                }

            VerificationView()
                .tabItem {
                    Label("Verifizierung", systemImage: "checkmark.shield")
                }

            LogbookView()
                .tabItem {
                    Label("Logs", systemImage: "doc.plaintext")
                }
        }
        .tint(.indigo)
    }
}
