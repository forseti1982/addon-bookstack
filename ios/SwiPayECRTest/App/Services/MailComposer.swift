import Foundation

#if canImport(UIKit)
import UIKit
#endif

struct MailComposer {
    static func makeMailtoURL(subject: String, body: String, recipient: String) -> URL? {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? body
        let target = recipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? recipient
        return URL(string: "mailto:\(target)?subject=\(encodedSubject)&body=\(encodedBody)")
    }

    #if canImport(UIKit)
    static func openMailClient(_ url: URL) -> Bool {
        guard UIApplication.shared.canOpenURL(url) else { return false }
        UIApplication.shared.open(url)
        return true
    }
    #endif
}
