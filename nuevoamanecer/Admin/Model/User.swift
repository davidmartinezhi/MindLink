//
//  User.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import Foundation

struct User : Codable, Identifiable, Hashable  {
    let id: String
    let name: String
    let email: String
    let isAdmin: Bool
    let image: String
}
