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
    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //tags
    let tags: [String] = ["Información Personal","Contacto","Historial Médico","Diagnóstico","Tratamiento","Soporte Familiar","Consentimientos","Otro"]
    @State private var selectedTag: String = ""

    
    func initializeData(note: Note) -> Void{
        noteTitle = note.title
        noteContent = note.text
        selectedTag = note.tag
    }
    
    var body: some View {
        VStack {
            
            Form {
                Section(header: Text("Título")) {
                    TextField("Título de la nota", text: $noteTitle)
                }
                
                Section(header: Text("Etiqueta")) {
                    Picker("Seleccionar Etiqueta", selection: $selectedTag) {
                        Text("Ninguna").tag("")
                        ForEach(tags, id: \.self) { tag in
                            Text(tag).tag(tag)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Contenido")) {
                    TextEditor(text: $noteContent)
                        //.fixedSize(horizontal: false, vertical: true)
                        .frame(minHeight: 450)
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
                        self.alertTitle = "Texto no válido"
                        self.alertMessage = "El título y el contenido no pueden contener solamente espacios en blanco"
                        self.showingAlert = true
                    }
                    else if hasLeadingWhitespace(input: noteTitle) || hasLeadingWhitespace(input: noteContent){
                        self.alertTitle = "Texto no válido"
                        self.alertMessage = "El título y el contenido no pueden iniciar con campos en blanco"
                        self.showingAlert = true
                    }
                    else {
                        //let newNote = Note(id: note.id, patientId: note.patientId, order: note.order, title: noteTitle, text: noteContent)
                        self.note.title = removeTrailingWhitespace(from: noteTitle)
                        self.note.text = removeTrailingWhitespace(from: noteContent)
                        self.note.tag = selectedTag
                        
                        self.notes.updateData(note: note){ error in
                            if error != "OK" {
                                self.alertTitle = "Error"
                                self.alertMessage = "Se produjo un error al guardar los cambios."
                                self.showingAlert = true
                            } else {
                                self.notes.notesList = self.notes.notesList.map {$0.id == note.id ? note : $0}
                                self.filteredNotes = self.filteredNotes.map {$0.id == note.id ? note : $0}
                                
                                dismiss()
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
        .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
        .onAppear{initializeData(note: note)}
    }
}
