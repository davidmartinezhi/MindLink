//
//  Note.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 24/05/23.
//

import Foundation

struct Note: Hashable, Codable, Identifiable, Equatable {
    //var id: ObjectIdentifier
    let id: String
    let patientId: String
    var order: Int
    var title: String
    var text: String
    var date: Date
    var tag: String
    
    static func == (lhs: Note, rhs: Note) -> Bool {
            return lhs.id == rhs.id
    }
}
