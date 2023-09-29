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
        
        do {
            try db.collection("Patient").addDocument(from: patient) { err in
                if let err = err {
                    completion(err.localizedDescription)
                } else {
                    completion("OK")
                }
            }
        } catch let error {
            completion(error.localizedDescription)
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
                do {
                    patients.append(try document.data(as: Patient.self))
                } catch {
                    return nil
                }
            }
            
            patients.sort { $0.firstName.lowercased() < $1.firstName.lowercased() }
            
            return patients
            
        }
        catch{
            print("Error al traer los datos")
            return nil
        }
    }
    
    
    // Recuperar paciente por ID
    func getPatientById(patientId: String) async -> Patient? {
        do {
            // Obtén el documento del paciente por ID
            let documentSnapshot = try await db.collection("Patient").document(patientId).getDocument()
            
            do {
                return try documentSnapshot.data(as: Patient.self)
            } catch {
                print("No se encontró el documento.")
                return nil
            }
        }
        catch {
            print("Error al traer los datos: \(error)")
            return nil
        }
    }
    
    
    // Edición de paciente
    func updateData(patient: Patient, completion: @escaping (String) -> Void) {
        do {
            try db.collection("Patient").document(patient.id!).setData(from: patient) { err in
                if let err = err {
                    completion(err.localizedDescription)
                } else {
                    completion("OK")
                }
            }
        } catch let error {
            completion(error.localizedDescription)
        }
    }
    
    func updateConfiguration(idPatient: String, voiceConfig: VoiceConfiguration, completion: @escaping (String?) -> Void) {
        db.collection("Patient").document(idPatient).setData(["voiceConfig": voiceConfig]) { err in
            if let err = err {
                completion(err.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteData(patient: Patient, completion: @escaping (String) -> Void) async {
        do {
            let patientRef = db.collection("Patient").document(patient.id!)
            
            // First delete all notes associated with the patient
            let notesRef = db.collection("Note").whereField("patientId", isEqualTo: patient.id!)
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
