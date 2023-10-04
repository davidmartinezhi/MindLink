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
        return name.count > 2
    }
    
    func hasValidEmail() -> Bool {
        return email.isValidEmail()
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
