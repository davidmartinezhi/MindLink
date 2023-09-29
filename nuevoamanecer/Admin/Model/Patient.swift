//
//  Patient.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Patient: Hashable, Codable, Identifiable {
    @DocumentID var id: String?
    let firstName: String
    let lastName: String
    let birthDate: Date
    let group: String
    let communicationStyle: String
    let cognitiveLevel: String
    let image: String
    let notes: [String]
    let identificador: String
    var voiceConfig : VoiceConfiguration = VoiceConfiguration()
    
    func buildPatientTitle() -> String {
        return firstName + " " + lastName.prefix(upTo: lastName.firstIndex(of: " ") ?? lastName.endIndex)
    }
    
    static func ==(lhs: Patient, rhs: Patient) -> Bool {
        return lhs.id == rhs.id
    }
}

struct VoiceConfiguration : Codable , Hashable {
    var talkingSpeed : String = "Normal"
    var voiceGender : String = "Femenina"
    var voiceAge : String = "Adulta"
}
