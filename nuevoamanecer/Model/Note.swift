//
//  Note.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 24/05/23.
//

import Foundation

struct Note: Hashable {
    //var id: ObjectIdentifier
    let id: String
    let patientId: String
    var order: Int
    let title: String
    let text: String
}
