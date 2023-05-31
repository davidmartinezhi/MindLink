//
//  AddNoteView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 25/05/23.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var notes: NotesViewModel
    var patient: Patient
    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Text("Agregar nota")
                .font(.largeTitle)
                .padding(.bottom)
            
            Form {
                Section(header: Text("Título")) {
                    TextField("Introduce el título de la nota", text: $noteTitle)
                }
                
                Section(header: Text("Contenido")) {
                    TextEditor(text: $noteContent)
                }
            }
            
            Button(action: {
                if noteTitle.isEmpty || noteContent.isEmpty {
                    self.alertTitle = "Faltan campos"
                    self.alertMessage = "Por favor, rellena todos los campos antes de guardar la nota."
                    self.showingAlert = true
                } else {
                    let newNote = Note(id: UUID().uuidString, patientId: patient.id, order: patient.notes.count + 1, title: noteTitle, text: noteContent)
                    
                    notes.addData(patient: patient, note: newNote) { response in
                        if response == "OK" {
                            self.alertTitle = "Nota guardada"
                            self.alertMessage = "La nota ha sido guardada con éxito."
                            self.showingAlert = false
                            
                            Task{
                                if let notesList = await notes.getDataById(patientId: patient.id){
                                    DispatchQueue.main.async{
                                        self.notes.notesList = notesList.sorted { $0.order < $1.order }
                                        dismiss()
                                    }
                                }
                            }
                            
                        } else {
                            self.alertTitle = "Error"
                            self.alertMessage = response
                            self.showingAlert = true
                        }
                    }
                }
            }) {
                Text("Guardar nota")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(40)
            }
            .padding(.horizontal)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(notes: NotesViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()))
    }
}
