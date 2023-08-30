//
//  Helpers.swift
//  nuevoamanecer
//
//  Created by David Gerardo Martínez on 21/08/23.
//

import Foundation


/*
 input: String
 output: Bool
 description: Función para validar si el string no constiene white spaces
*/
func isValidInputNoWhiteSpaces(input: String) -> Bool {
    let pattern = "^\\s*$" // Expresión regular que coincide con cadenas que contienen solo espacios en blanco
    let regex = try? NSRegularExpression(pattern: pattern)
    let matches = regex?.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))
    return matches?.isEmpty ?? true // Devuelve true si no hay coincidencias (es decir, la entrada no está vacía y no contiene solo espacios en blanco)
}


/*
 input: String
 output: Bool
 description: Función para validar si un nombre es válido utilizando una expresión regular
 */
func isValidName(name: String) -> Bool {
    // Elimina los espacios en blanco al final del nombre
    let trimmedName = name.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    
    // Expresión regular para validar el nombre
    let pattern = "^[A-Za-zÀ-ÖØ-öø-ÿ]+(?: [A-Za-zÀ-ÖØ-öø-ÿ]+)*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: trimmedName.utf16.count)
    return regex?.firstMatch(in: trimmedName, options: [], range: range) != nil
}

/*
 input: String
 output: Bool
 description: Devuelve true si hay coincidencias (es decir, la entrada tiene espacios en blanco al principio)
 */
func hasLeadingWhitespace(input: String) -> Bool {
    let pattern = "^\\s"
    let regex = try? NSRegularExpression(pattern: pattern)
    let matches = regex?.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))
    return !(matches?.isEmpty ?? true)
}


/*
 input: String
 output: Bool
 description: Función para validar si un string no tiene espacio en blanco al inicio y solo contiene letras y numeros
 */
func isValidOnlyCharAndNumbers(input: String) -> Bool {
    let pattern = "^[a-zA-Z0-9áéíóúÁÉÍÓÚüÜñÑ][a-zA-Z0-9áéíóúÁÉÍÓÚüÜñÑ\\s]*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let matches = regex?.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))
    return !(matches?.isEmpty ?? true) // Devuelve true si hay coincidencias (es decir, la entrada es válida)
}




/*
 input: String
 output: Bool
 description: Función para validar si una fecha de cumpleaños es válida, siendo almenos con una fecha pcon un mes previo
 */
func isValidBirthDate(birthDate: Date) -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate)!
    
    // Verifica si la fecha de nacimiento está en el futuro
    if birthDate.compare(currentDate) == .orderedDescending {
        return false
    }
    
    // Verifica si la fecha de nacimiento está en el mes previo
    if birthDate.compare(oneMonthAgo) == .orderedDescending {
        return false
    }
    
    return true
}


/*
 input: String
 output: String
 description: Función para remover espacios en blanco al final de un string
 */
func removeTrailingWhitespace(from string: String) -> String {
    return string.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
}

