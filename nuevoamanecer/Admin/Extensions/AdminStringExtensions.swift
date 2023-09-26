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
    
    func isWeak() -> Bool {
        var containsSynbol = false
        var containsNumber = false
        var containsUpercase = false
        
        for character in self {
            if ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character)){
                containsUpercase = true
            }
            if ("1234567890".contains(character)){
                containsNumber = true
            }
            if ("!?#$%&/()=;:_-.,°".contains(character)){
                containsSynbol = true
            }
        }
        
        return self.count > 8 && containsSynbol && containsUpercase && containsNumber
    }
}
