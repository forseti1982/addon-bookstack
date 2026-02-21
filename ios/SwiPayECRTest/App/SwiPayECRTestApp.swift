import SwiftUI

@main
struct SwiPayECRTestApp: App {
    @StateObject private var terminalStore = TerminalStore()
    @StateObject private var logService = LogService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(terminalStore)
                .environmentObject(logService)
        }
    }
}
