import SwiftUI

struct LogbookView: View {
    @EnvironmentObject private var logService: LogService

    @State private var recipient = "support@swipay.example"
    @State private var info = ""

    var body: some View {
        NavigationStack {
            VStack {
                List(logService.entries) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.level.rawValue).font(.caption).foregroundStyle(.secondary)
                        Text(entry.message)
                    }
                }

                HStack {
                    TextField("Empfänger", text: $recipient)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.roundedBorder)

                    Button("Logs senden") {
                        let body = logService.exportTranscript()
                        guard let mailURL = MailComposer.makeMailtoURL(
                            subject: "SwiPay | ECR Test Kommunikationsverlauf",
                            body: body,
                            recipient: recipient
                        ) else {
                            info = "Konnte Mail nicht vorbereiten."
                            return
                        }

                        #if canImport(UIKit)
                        if MailComposer.openMailClient(mailURL) {
                            info = "Mail-App geöffnet."
                        } else {
                            info = "Kein Mail-Client verfügbar."
                        }
                        #else
                        info = "Mailversand ist nur auf iOS verfügbar."
                        #endif
                    }
                }
                .padding(.horizontal)

                if !info.isEmpty {
                    Text(info).font(.caption).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Kommunikationslog")
        }
    }
}
