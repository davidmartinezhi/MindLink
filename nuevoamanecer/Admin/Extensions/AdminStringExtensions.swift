//
//  StringExtensions.swift
//  nuevoamanecer
//
//  Created by emilio on 23/09/23.
//

import Foundation

extension String {
    func splitAtWhitespaces() -> [String] {
        return self.split(separator: " ").map(String.init)
    }
                
    func trimAtEnds() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeWhitespaces() -> String {
        return self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: nil)
    }
    
    func isValidEmail() -> Bool {
        return self.contains(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
    }
}
