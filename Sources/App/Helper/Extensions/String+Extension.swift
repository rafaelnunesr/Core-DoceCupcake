import Foundation

extension String {
    static var empty: String {
        return ""
    }

    @inlinable var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: self)
    }

    @inlinable var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Za-z]).{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: self)
    }

    @inlinable var dateValue: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: self)
    }
    
    @inlinable var uuid: UUID {
        UUID(uuidString: self) ?? UUID()
    }
}

