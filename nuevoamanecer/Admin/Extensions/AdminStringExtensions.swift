//
//  StringExtensions.swift
//  nuevoamanecer
//
//  Created by emilio on 23/09/23.
//

import Foundation

extension String {
    func isWeakPassword() -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*\\(\\)_\\-\\.,;:]).{9,}$")
            return passwordRegex.evaluate(with: self)
    }
    
    func splitAtWhitespaces() -> [String] {
        return self.split(separator: " ").map(String.init)
    }
    
    func isValidEmail() -> Bool {
        return self.contains(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
    }
}
