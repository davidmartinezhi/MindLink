//
//  VoiceConfigurationViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 05/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class VoiceSettingViewModel {
    var voiceSettingCollection: CollectionReference = Firestore.firestore().collection("voiceSettings")
    
    func getVoiceSetting(patientId: String, completition: @escaping (Error?, VoiceSetting?)->Void) -> Void {
        self.voiceSettingCollection.whereField("patientId", isEqualTo: patientId).getDocuments { querySnapshot, error in
            if error != nil || querySnapshot == nil {
                completition(error, nil)
            } else {
                completition(nil, try? querySnapshot!.documents.first?.data(as: VoiceSetting.self))
            }
        }
    }
    
    func editVoiceSetting(voiceSettingId: String, voiceSetting: VoiceSetting, completition: @escaping (Error?)->Void) -> Void {
        do {
            try voiceSettingCollection.document(voiceSettingId).setData(from: voiceSetting) { error in
                if error != nil {
                    completition(error)
                } else {
                    completition(nil)
                }
            }
        } catch let error {
            completition(error)
        }
    }
    
    func createVoiceSetting(voiceSetting: VoiceSetting = VoiceSetting.defaultVoiceSetting(), completition: @escaping (Error?, String?)->Void) {
        var docRef: DocumentReference? = nil
        
        do {
            docRef = try voiceSettingCollection.addDocument(from: voiceSetting) { error in
                if error != nil {
                    completition(error, nil)
                } else {
                    completition(nil, docRef?.documentID)
                }
            }
        } catch let error {
            completition(error, nil)
        }
    }
}
