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
                let birthDate = data["birthDate"] as? Date ?? Date()
                let group = data["group"] as? String ?? "No asignado"
                let communicationStyle = data["communicationStyle"] as? String ?? "No asignado"
                let cognitiveLevel = data["cognitiveLevel"] as? String ?? "No asignado"
                let image = data["image"] as? String ?? ""
                let notes = data["notes"] as? [String] ?? []
                //let id = data["id"] as? String ?? UUID().uuidString
                let id = document.documentID
                
                let patient = Patient(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyle, cognitiveLevel: cognitiveLevel, image: image, notes: notes)
                
                patients.append(patient)
            }
            
            return patients
            
        }
        catch{
            print("Error al traer los datos")
        }
        
        return nil
    }
    
    
}
