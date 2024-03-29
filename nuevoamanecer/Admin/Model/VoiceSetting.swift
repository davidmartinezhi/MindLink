//
//  VoiceConfiguration.swift
//  nuevoamanecer
//
//  Created by emilio on 05/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct VoiceSetting: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var talkingSpeed: String
    var voiceGender: String
    var voiceAge: String
    var patientId: String? 
    
    static func defaultVoiceSetting(patientId: String? = nil) -> VoiceSetting {
        return VoiceSetting(talkingSpeed: "Normal", voiceGender: "Femenina", voiceAge: "Adulta", patientId: patientId)
    }
}
