//
//  Patient.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import Foundation

struct Patient: Hashable{
    var id: String
    let firstName: String
    let lastName: String
    let birthDate: Date
    let group: String
    let communicationStyle: String
    let cognitiveLevel: String
    let image: String
    let notes: [String]
}
