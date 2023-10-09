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
    @Binding var filteredNotes: [Note]
    @Binding var search: String

    var patient: Patient
    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //tags
    let tags: [String] = ["Información Personal","Contacto","Historial Médico","Diagnóstico","Tratamiento","Soporte Familiar","Consentimientos","Otro"]
    @State private var selectedTag: String = ""
    
    @State var isSaving : Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Título")) {
                    TextField("Introduce el título de la nota", text: $noteTitle)
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
                    //Dynamic expand
                    TextField("Contenido de la nota", text: $noteContent, axis: .vertical)
                        //.frame(minHeight: 450)
                    
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
                        isSaving = true
                        let newNote = Note(id: UUID().uuidString, patientId: patient.id, order: (patient.notes.count * -1) - 1, title: removeTrailingWhitespace(from: noteTitle) , text: removeTrailingWhitespace(from: noteContent) , date: Date(), tag: selectedTag)
                        
                        notes.addData(patient: patient, note: newNote) { response in
                            if response == "OK" {
                                self.alertTitle = "Nota guardada"
                                self.alertMessage = "La nota ha sido guardada con éxito."
                                self.showingAlert = false
                                
                                search = ""
                                
                                Task{
                                    if let notesList = await notes.getDataById(patientId: patient.id){
                                        DispatchQueue.main.async{
                                            self.notes.notesList = notesList.sorted { $0.order < $1.order }
                                            self.filteredNotes = self.notes.notesList
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
                .allowsHitTesting(!isSaving)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding()
        .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State(initialValue: []) var previewFilteredNotes: [Note]
        @State(initialValue: "") var previewSearch: String  // Nueva propiedad
        
        var body: some View {
            AddNoteView(notes: NotesViewModel(), filteredNotes: $previewFilteredNotes, search: $previewSearch, patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String](), identificador: ""))
        }
    }
}
