//
//  Note.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 24/05/23.
//

import Foundation

struct Note: Hashable, Codable, Identifiable  {
    //var id: ObjectIdentifier
    let id: String
    let patientId: String
    var order: Int
    var title: String
    var text: String
}
