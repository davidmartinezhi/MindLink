//
//  NotesViewModel.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 24/05/23.
//

import Foundation
import FirebaseFirestore


class NotesViewModel: ObservableObject{
    
    @Published var notesList = [Note]()
    
    
    let db = Firestore.firestore()
    
    init(){

    }
    
    
    func addData(patient: Patient, note: Note, completion: @escaping (String) -> Void) {
        
        let docRef = db.collection("Note").document()
        
        
        docRef.setData(["id": note.id, "patientId": note.patientId, "order": (notesList.count * -1) - 1, "title": note.title, "text": note.text, "date": note.date, "tag":note.tag]) { err in
            if let err = err {
                completion(err.localizedDescription)
            } else {
                self.updatePatientDocument(patient: patient, note: note) { response in
                    if response == "OK" {
                        completion("OK")
                    } else {
                        completion(response)
                    }
                }
            }
        }
    }

    
    
    //Regresa notas del paciente
    func getData() async -> [Note]?{
        
        do{
            //get documents from collection
            let querySnapshot = try await db.collection("Note").getDocuments()
            
            var notes = [Note]() //inicializo array de tipo Note
            
            //recorro documentso de la colección
            for document in querySnapshot.documents{
                let data = document.data()
                let patientId = data["patientId"] as? String ?? ""
                let order = data["order"] as? Int ?? 0
                let title = data["title"] as? String ?? ""
                let text = data["text"] as? String ?? ""
                let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                //let id = data["id"] as? String ?? UUID().uuidString
                let tag = data["tag"] as? String ?? ""
                let id = document.documentID
                
                let note = Note(id: id, patientId: patientId, order: order, title: title, text: text, date: date, tag: tag)
                notes.append(note)
            }
            
            return notes
                
        }
        catch{
            print("Error al traer los datos")
        }
        
        return nil
        
    }
    
    // Regresa notas del paciente especifico
    func getDataById(patientId: String) async -> [Note]? {
        do {
            // get documents from collection where patientId equals the provided patientId
            let querySnapshot = try await db.collection("Note")
                .whereField("patientId", isEqualTo: patientId)
                .getDocuments()

            var notes = [Note]() // inicializo array de tipo Note

            // recorro documentos de la colección
            for document in querySnapshot.documents {
                let data = document.data()
                let id = document.documentID
                let order = data["order"] as? Int ?? 0
                let title = data["title"] as? String ?? ""
                let text = data["text"] as? String ?? ""
                let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                let tag = data["tag"] as? String ?? ""
                
                let note = Note(id: id, patientId: patientId, order: order, title: title, text: text, date: date, tag: tag)
                notes.append(note)
            }

            return notes
        } catch {
            print("Error al traer los datos")
        }

        return nil
    }
    
    
    // Actualización de nota
    func updateData(note: Note, completion: @escaping (String) -> Void) {
        
        let noteRef = db.collection("Note").document(note.id)

        noteRef.updateData([
            "patientId": note.patientId,
            "order": note.order,
            "title": note.title,
            "text": note.text,
            "tag": note.tag
        ]) { err in
            if let err = err {
                completion(err.localizedDescription)
            } else {
                completion("OK")
            }
        }
    }
        
    // Eliminación de nota
    func deleteData(noteId: String, completion: @escaping (String) -> Void) {
        let noteRef = db.collection("Note").document(noteId)
        
        noteRef.delete() { err in
            if let err = err {
                completion(err.localizedDescription)
            } else {
                completion("OK")
            }
        }
    }

    
    // Actualización de documento de paciente
    private func updatePatientDocument(patient: Patient, note: Note, completion: @escaping (String) -> Void) {
        let patientRef = db.collection("Patient").document(patient.id)
        var patientNotes = patient.notes
        patientNotes.append(note.id)
            
        patientRef.updateData([
            "notes": patientNotes
        ]) { err in
            if let err = err {
                completion(err.localizedDescription)
            } else {
                completion("OK")
            }
        }
    }
}
