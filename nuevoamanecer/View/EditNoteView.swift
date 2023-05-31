//
//  EditNoteView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 30/05/23.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var notes: NotesViewModel
    @State var note: Note
    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    
    
    func initializeData(note: Note) -> Void{
        noteTitle = note.title
        noteContent = note.text
    }
    
    var body: some View {
        VStack {
            Text("Editar nota")
                .font(.largeTitle)
                .padding(.bottom)
            
            Form {
                Section(header: Text("Título")) {
                    TextField("Título de la nota", text: $noteTitle)
                }
                
                Section(header: Text("Contenido")) {
                    TextEditor(text: $noteContent)
                        .frame(minHeight: 400)
                }
            }
            
            Button(action: {
                if noteTitle.isEmpty || noteContent.isEmpty {
                    self.alertTitle = "Faltan campos"
                    self.alertMessage = "Por favor, rellena todos los campos antes de guardar la nota."
                    self.showingAlert = true
                } else {
                    
                    //let newNote = Note(id: note.id, patientId: note.patientId, order: note.order, title: noteTitle, text: noteContent)
                    self.note.title = noteTitle
                    self.note.text = noteContent
                    
                    notes.updateData(note: note){ error in
                        if error != "OK" {
                            print(error)
                        }
                        else{
                            Task{
                                if let notesList = await notes.getDataById(patientId: note.patientId){
                                    DispatchQueue.main.async{
                                        self.notes.notesList = notesList.sorted { $0.order < $1.order }
                                        dismiss()
                                    }
                                }
                            }
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
        .onAppear{initializeData(note: note)}
    }
}
struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EditNoteView(notes: NotesViewModel(), note: Note(id: "", patientId: "", order: 0, title: "", text: ""))
    }
}
