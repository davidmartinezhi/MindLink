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
    @Binding var filteredNotes: [Note]  // Nueva propiedad
    @State var note: Note
    @Binding var search: String
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
            
            Form {
                Section(header: Text("Título")) {
                    TextField("Título de la nota", text: $noteTitle)
                }
                
                Section(header: Text("Contenido")) {
                    TextEditor(text: $noteContent)
                        .frame(minHeight: 200)
                }
            }
            
            HStack{
                //Cancel
                Button(action: {
                    dismiss()
                }){
                    HStack {
                        Text("Cancelar")
                            .font(.headline)
                        
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
                
                
                //Save
                Button(action: {
                    if noteTitle.isEmpty || noteContent.isEmpty {
                        self.alertTitle = "Faltan campos"
                        self.alertMessage = "Por favor, rellena todos los campos antes de guardar la nota."
                        self.showingAlert = true
                    }
                    else if !isValidInputNoWhiteSpaces(input: noteTitle) || !isValidInputNoWhiteSpaces(input: noteContent){
                        self.alertTitle = "Texto no valido"
                        self.alertMessage = "El titulo y el contenido no pueden contener solamente espacios en blanco"
                        self.showingAlert = true
                    }
                    else if hasLeadingWhitespace(input: noteTitle) || hasLeadingWhitespace(input: noteContent){
                        self.alertTitle = "Texto no valido"
                        self.alertMessage = "El titulo y el contenido no pueden iniciar con campos en blanco"
                        self.showingAlert = true
                    }
                    else {
                        //let newNote = Note(id: note.id, patientId: note.patientId, order: note.order, title: noteTitle, text: noteContent)
                        self.note.title = removeTrailingWhitespace(from: noteTitle)
                        self.note.text = removeTrailingWhitespace(from: noteContent)
                        
                        notes.updateData(note: note){ error in
                            if error != "OK" {
                                print(error)
                            }
                            else{
                                search = ""
                                Task{
                                    if let notesList = await notes.getDataById(patientId: note.patientId){
                                        DispatchQueue.main.async{
                                            self.notes.notesList = notesList.sorted { $0.order < $1.order }
                                            self.filteredNotes = self.notes.notesList  // Actualizar filteredNotes

                                            dismiss()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }) {
                    HStack {
                        Text("Guardar")
                            .font(.headline)
                        
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
            }
        }
        .padding()
        .onAppear{initializeData(note: note)}
    }
}

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State(initialValue: []) var previewFilteredNotes: [Note]  // Nueva propiedad
        @State(initialValue: "") var previewSearch: String  // Nueva propiedad

        var body: some View {
            EditNoteView(notes: NotesViewModel(), filteredNotes: $previewFilteredNotes, note: Note(id: "", patientId: "", order: 0, title: "", text: "", date: Date(), tags: []), search: $previewSearch)
        }
    }
}
