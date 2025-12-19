import Foundation

enum Validator {

    // MARK: - Email

    static func isValidEmail(_ email: String) -> Bool {
        let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue
        )

        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = detector?.matches(in: email, options: [], range: range)

        return matches?.first?.url?.scheme == "mailto"
    }

    // MARK: - Birthdate (dd.MM.yyyy)

    static func isValidBirthDate(_ text: String) -> Bool {
        return birthDateFormatter.date(from: text) != nil
    }

    // MARK: - Private formatter (singleton)

    private static let birthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.isLenient = false
        return formatter
    }()
}
