//
//  PatientsModel.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import Foundation
import FirebaseFirestore

class PatientsViewModel: ObservableObject{
    @Published var patientsList = [Patient]()
    
    let db = Firestore.firestore()
    
    //Al inicializar jala la info de los pacientes
    init(){
        Task{
            if let patients = await getData(){
                DispatchQueue.main.async {
                    self.patientsList = patients
                }
            }
        }
    }
    
    //Creación de paciente
    func addData(patient : Patient, completion: @escaping (String) -> Void){
        
        db.collection("Patient").addDocument(data: ["id": patient.id ,"firstName": patient.firstName, "lastName": patient.lastName, "birthDate": patient.birthDate, "group": patient.group, "communicationStyle": patient.communicationStyle, "cognitiveLevel": patient.cognitiveLevel, "image": patient.image, "notes": [String]()]){ err in
            
            if let err = err {
                completion(err.localizedDescription)
            }
            else{
                completion("OK")
            }
        }
    }
    
    //Recuperar pacientes
    func getData() async -> [Patient]?{
        do{
            //get documents from collection
            let querySnapshot = try await db.collection("Patient").getDocuments()
            
            var patients = [Patient]() //inicializo array de tipo Patient
            
            //recorro documentso de la colección
            for document in querySnapshot.documents{
                let data = document.data()
                
                let firstName = data["firstName"] as? String ?? ""
                let lastName = data["lastName"] as? String ?? ""
                let birthDate = (data["birthDate"] as? Timestamp)?.dateValue() ?? Date()
                let group = data["group"] as? String ?? "No asignado"
                let communicationStyle = data["communicationStyle"] as? String ?? "No asignado"
                let cognitiveLevel = data["cognitiveLevel"] as? String ?? "No asignado"
                let image = data["image"] as? String ?? ""
                let notes = data["notes"] as? [String] ?? []
                //let id = data["id"] as? String ?? UUID().uuidString
                let id = document.documentID
                let identificador = data["id"] as? String ?? ""
                
                let patient = Patient(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyle, cognitiveLevel: cognitiveLevel, image: image, notes: notes, identificador: identificador)
                
                patients.append(patient)
            }
            
            patients.sort { $0.firstName.lowercased() < $1.firstName.lowercased() }
            
            return patients
            
        }
        catch{
            print("Error al traer los datos")
        }
        
        return nil
    }
    
    
    // Recuperar paciente por ID
    func getPatientById(patientId: String) async -> Patient? {
        do {
            // Obtén el documento del paciente por ID
            let documentSnapshot = try await db.collection("Patient").document(patientId).getDocument()
            
            guard let data = documentSnapshot.data() else {
                print("No se encontró el documento.")
                return nil
            }
            
            let firstName = data["firstName"] as? String ?? ""
            let lastName = data["lastName"] as? String ?? ""
            let birthDate = data["birthDate"] as? Date ?? Date()
            let group = data["group"] as? String ?? "No asignado"
            let communicationStyle = data["communicationStyle"] as? String ?? "No asignado"
            let cognitiveLevel = data["cognitiveLevel"] as? String ?? "No asignado"
            let image = data["image"] as? String ?? ""
            let notes = data["notes"] as? [String] ?? []
            let identificador = data["id"] as? String ?? ""
            let talkingSpeed = data["talkingSpeed"] as? String ?? "Normal"
            let voiceGender = data["voiceGender"] as? String ?? "Femenina"
            let voiceAge = data["voiceAge"] as? String ?? "Adulta"
            
            let patient = Patient(id: patientId, firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyle, cognitiveLevel: cognitiveLevel, image: image, notes: notes, identificador: identificador, talkingSpeed: talkingSpeed, voiceGender: voiceGender, voiceAge: voiceAge)
            
            return patient
        }
        catch {
            print("Error al traer los datos: \(error)")
            return nil
        }
    }
    
    
    // Edición de paciente
    func updateData(patient: Patient, completion: @escaping (String) -> Void) {
        db.collection("Patient").document(patient.id).updateData([
            "firstName": patient.firstName,
            "lastName": patient.lastName,
            "birthDate": patient.birthDate,
            "group": patient.group,
            "communicationStyle": patient.communicationStyle,
            "cognitiveLevel": patient.cognitiveLevel,
            "image": patient.image,
            "notes": patient.notes
        ]) { err in
            if let err = err {
                completion(err.localizedDescription)
            } else {
                completion("OK")
            }
        }
    }
    
    func deleteData(patient: Patient, completion: @escaping (String) -> Void) async {
        do {
            let patientRef = db.collection("Patient").document(patient.id)
            
            // First delete all notes associated with the patient
            let notesRef = db.collection("Note").whereField("patientId", isEqualTo: patient.id)
            let notesSnapshot = try await notesRef.getDocuments()

            for document in notesSnapshot.documents {
                try await db.collection("Note").document(document.documentID).delete()
            }

            // Then delete the patient
            try await patientRef.delete()
            completion("OK")
        } catch {
            print("Error removing patient: \(error)")
            completion("Failed")
        }
    }
}
