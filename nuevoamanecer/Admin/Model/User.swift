//
//  User.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable, Equatable  {
    @DocumentID var id: String?
    var name: String
    var email: String
    var isAdmin: Bool
    var image: String?
    
    func isValidUser() -> Bool {
        var result: Bool = true
        result = result && self.hasValidName()
        result = result && self.hasValidEmail()
        return result
    }
    
    func hasValidName() -> Bool {
        return self.name.count < 21 && self.name.count > 3 && self.name.contains(/^[A-Za-z]+(?: [A-Za-z]+)*$/)
        // Contiene por lo menos 4 caracteres.
        // Contiene no más de 20 caracters.
        // No termina o inicia con espacios.
        // Contiene solamente caracteres alfabéticos.
        // Entre caracteres alfabéticos hay no más de un espacio. 
    }
    
    func hasValidEmail() -> Bool {
        return self.email.contains(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
    }
    
    func toDict() -> [String:Any] {
        var userDict: [String:Any] = ["name": name, "email": email, "isAdmin": isAdmin]
        
        if image != nil {
            userDict["image"] = image!
        }
        
        return userDict
    }
    
    static func newEmptyUser() -> User {
        return User(name: "", email: "", isAdmin: false)
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        var result: Bool = true
        result = result && lhs.id == rhs.id
        result = result && lhs.name == rhs.name
        result = result && lhs.email == rhs.email
        result = result && lhs.isAdmin == rhs.isAdmin
        result = result && lhs.image == rhs.image
        return result
    }
}
