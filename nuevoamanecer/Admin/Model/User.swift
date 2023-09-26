//
//  User.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable  {
    @DocumentID var id: String?
    var name: String
    var email: String
    var isAdmin: Bool
    var image: String? 
}
