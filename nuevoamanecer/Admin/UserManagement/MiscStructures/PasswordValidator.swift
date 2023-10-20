//
//  PasswordValidityState.swift
//  nuevoamanecer
//
//  Created by emilio on 20/10/23.
//

import Foundation

// Reglas que contraseñas de usuario deben obedecer:
// Contiene por lo menos 8 caracteres.
// Contiene por lo menos una mayúscula.
// Contiene por lo menos una minúscula.
// Contiene por lo menos un número.
// Contains only numbers and alphabetical characters. 

struct PasswordValidator {
    let password: String
    
    init(_ password: String) {
        self.password = password
    }

    func isValidPassword() -> Bool {
        return self.password.contains(/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$/)
    }
    
    func hasValidLength() -> Bool {
        return self.password.count > 7
    }
    
    func hasAnUppercaseLetter() -> Bool {
        return self.password.contains(/^.*[A-Z].*$/)
    }
    
    func hasALowercaseLetter() -> Bool {
        return self.password.contains(/^.*[a-z].*$/)
    }
    
    func hasANumber() -> Bool {
        return self.password.contains(/^.*\d.*$/)
    }
    
    func containsOnlyLettersAndNumbers() -> Bool {
        return self.password.contains(/^[a-zA-Z0-9]+$/)
    }
    
    func buildValidationList() -> [String:Bool] {
        return [
            "Contiene más de 8 caracteres": self.hasValidLength(),
            "Contiene una letra mayúscula": self.hasAnUppercaseLetter(),
            "Contiene una letra minúscula": self.hasALowercaseLetter(),
            "Contiene un número": self.hasANumber(),
            "Contiene únicamente números y letras": self.containsOnlyLettersAndNumbers()
        ]
    }
}
