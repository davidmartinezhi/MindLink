//
//  PatientView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI
import Kingfisher

struct PatientView: View {
    var patient: Patient
    //@State var notes : NotesViewModel
    @State var showAddNoteView = false
    //@State var selectedNote: Note?
    @ObservedObject var notes : NotesViewModel
    @State private var notesList: [Note]! = []

    
    //Busqueda de notas
    private func getPatientNotes(patientId: String){
        Task{
            if let notesList = await notes.getDataById(patientId: patient.id){
                DispatchQueue.main.async{
                    self.notes.notesList = notesList
                }
            }
        }
    }
    
    
    var body: some View {
        
        HStack{
            // 1/4 of the screen for the notes list
            VStack {
                Text("Notas")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    showAddNoteView.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Agregar Nota")
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                
                List(notes.notesList, id: \.id) { note in
                    Text(note.title)
                        .onTapGesture {
                           // selectedNote = note
                        }
                }
                
            }
            .frame(width: UIScreen.main.bounds.width / 4)
            .background(Color(.systemGray6))
            
            // 3/4 of the screen for patient information and notes
            VStack {
                HStack {
                    VStack{
                        KFImage(URL(string: patient.image))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        //.overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        //.cornerRadius(16.0)
                            .padding(.trailing)
                    }
                    VStack(alignment: .leading) {
                        Text(patient.firstName + " " + patient.lastName)
                            .font(.title)
                        
                        // Add other patient details here
                        Text("Grupo: " + patient.group)
                            .font(.subheadline)
                        
                        // Add other patient details here
                        Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                            .font(.subheadline)
                        
                        // Add other patient details here
                        Text("Estilo de comunicación: " + patient.communicationStyle)
                            .font(.subheadline)
                    }
                    Spacer()
                    
                    Button(action: {
                        print("Comunicador")
                    }) {
                        Text("Comunicador")
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    
                    Button(action: {
                        // Handle settings action here
                    }) {
                        HStack{
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Editar")
                        }

                    }
                    .padding()
                }
                //.padding()
                
                Divider()
                
                //Text(selectedNote?.content ?? "Select a note")
                  //  .padding()
                
                List(notes.notesList, id:\.id){ note in
                    HStack{
                        VStack(alignment: .leading){
                            Text(note.title)
                                .font(.title)
                            Text(note.text)
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    
                    
                }
            }
        }
        .sheet(isPresented: $showAddNoteView) {
            AddNoteView(notes: notes, patient: patient)
            // Show the add note view here
            // For example:
            // AddNoteView(notes: $notes)
        }
        .onAppear{self.getPatientNotes(patientId: patient.id)}
        
        Spacer()
    }
}


struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView(patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()), notes: NotesViewModel())
    }
}
