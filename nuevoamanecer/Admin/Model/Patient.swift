//
//  Patient.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import Foundation

struct Patient: Hashable, Codable, Identifiable {
    var id: String
    let firstName: String
    let lastName: String
    let birthDate: Date
    let group: String
    let communicationStyle: String
    let cognitiveLevel: String
    let image: String
    let notes: [String]
    let identificador: String
    let voice : VoiceConfiguration
    
    func buildPatientTitle() -> String {
        return firstName + " " + lastName.prefix(upTo: lastName.firstIndex(of: " ") ?? lastName.endIndex)
    }
}

struct VoiceConfiguration : Codable , Hashable {
    var talkingSpeed : String = "Normal"
    var voiceGender : String = "Femenina"
    var voiceAge : String = "Adulta"
}
