//
//  PatientView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI
import Kingfisher



struct PatientView: View {
    
    //ViewModels
    @ObservedObject var patients : PatientsViewModel
    @ObservedObject var notes : NotesViewModel
    
    
    //patient
    var patient: Patient
    
    //showViews
    @State var showAddNoteView = false
    @State var showEditPatientView = false
    @State private var showDeleteNoteAlert = false
    @State var showEditNoteView = false
    
    //Note Selection
    @State private var selectedNoteIndex: Int?
    @State var selectedNote: Note?

    
    
    //Retrieve Notes of patient
    private func getPatientNotes(patientId: String){
        Task{
            if let notesList = await notes.getDataById(patientId: patient.id){
                DispatchQueue.main.async{
                    self.notes.notesList = notesList.sorted { $0.order < $1.order }
                }
            }
        }
    }
    
    
    //Delete note
    func deleteNote(at offsets: IndexSet){
        self.selectedNoteIndex = offsets.first
        showDeleteNoteAlert = true
    }
    
    //Move notes and save order in database
    func moveNote(from source: IndexSet, to destination: Int) {
        self.notes.notesList.move(fromOffsets: source, toOffset: destination)

        // Actualizar el orden de las notas en la base de datos
        for (index, note) in self.notes.notesList.enumerated() {
            // Creamos una copia de la nota para no modificar la original
            var updatedNote = note
            updatedNote.order = index + 1
            // Actualizamos la nota en la base de datos
            self.notes.updateData(note: updatedNote) { response in
                if response != "OK" {
                    // Aquí puedes manejar el error si lo deseas
                    print("Error al actualizar la nota \(updatedNote.id): \(response)")
                }
            }
        }
    }
    
    var body: some View {
        
        HStack{
            // 1/4 of the screen for the notes list
            VStack {
                HStack{
                    Text("Esquema")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.gray)
                        .padding()
                    
                    Spacer()
                }.padding(.top)

                HStack{
                    Button(action: {
                        showAddNoteView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Agregar Nota")
                        }
                    }
                    .padding()
                }
                

                List(notes.notesList, id: \.id) { note in
                    Text(note.title)
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color.black)
                        .onTapGesture {
                           selectedNote = note
                        }
                        .frame(minHeight: 50)
                }
                .listStyle(.sidebar)
                .padding(.top)
            }
            .frame(width: UIScreen.main.bounds.width / 4)
            .background(Color.white.opacity(0.1))

            
            // 3/4 of the screen for patient information and notes
            VStack {
                HStack {
                    VStack{
                        KFImage(URL(string: patient.image))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        //.shadow(radius: 10)
                            .padding(.trailing)
                    }
                    VStack(alignment: .leading) {
                        Text(patient.firstName + " " + patient.lastName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        
                        Text("Grupo: " + patient.group)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 5)
                        
                        // Add other patient details here
                        Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 5)
                        
                        // Add other patient details here
                        Text("Estilo de comunicación: " + patient.communicationStyle)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 5)
                    }
                    Spacer()
                    
                    VStack{
                        Button(action: {
                            // Handle settings action here
                            showEditPatientView.toggle()
                            
                        }) {
                            HStack{
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Editar")
                            }
                            
                        }
                        
                        
                        Button(action: {
                            print("Comunicador")
                        }) {
                            Text("Comunicador")
                                .font(.system(size: 16, weight: .bold))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                .padding(.trailing)
                
                //Divider()
                
                //Lista de pacientes
                List {
                    ForEach(Array(notes.notesList.enumerated()), id: \.element.id) { index, note in
                        
                        //Tarjeta paciente
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text(note.title)
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .padding(.bottom, 2)
                                    Text(note.text)
                                        .font(.system(size: 18, weight: .regular))
                                        .foregroundColor(Color.gray)
                                        .padding([.bottom, .top, .trailing])
                                        
                                }
                                Spacer()
                            }
                            .padding([.top, .bottom], 10)
                            .padding([.leading, .trailing], 15)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            //.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .frame(minHeight: 150)
                        .padding([.top, .bottom], 5)
                        .swipeActions(edge: .trailing) {
                            Button {
                                selectedNote = note
                                showDeleteNoteAlert = true
                                selectedNoteIndex = index
                                
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                            .tint(.red)
                            .padding()
                            
                            Button {
                                // Aquí va la lógica para actualizar la nota
                                selectedNote = note
                                showEditNoteView = true
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            .tint(.blue)
                            .padding()
                        }
                    }
                    .onMove(perform: moveNote)
                    .padding(.top)
                    .alert(isPresented: $showDeleteNoteAlert) {
                        Alert(title: Text("Eliminar Nota"),
                              message: Text("¿Estás seguro de que quieres eliminar esta nota? Esta acción no se puede deshacer."),
                              primaryButton: .destructive(Text("Eliminar")) {
                                  // Confirmar eliminación
                                  if let index = self.selectedNoteIndex {
                                      let noteId = notes.notesList[index].id
                                      notes.deleteData(noteId: noteId) { response in
                                          if response == "OK" {
                                              notes.notesList.remove(atOffsets: IndexSet(integer: index))
                                          } else {
                                              // Aquí puedes manejar el error si lo deseas
                                              print("Error al eliminar la nota: \(response)")
                                          }
                                      }
                                  }
                                  self.selectedNoteIndex = nil
                              },
                              secondaryButton: .cancel {
                                  // Cancelar eliminación
                                  self.selectedNoteIndex = nil
                              })
                    }
                }
                .listStyle(.inset)
            }
        }
        .sheet(isPresented: $showAddNoteView) {
            AddNoteView(notes: notes, patient: patient)
        }
        .sheet(isPresented: $showEditNoteView){
            EditNoteView(notes: notes, note: selectedNote!)
            
        }
        .sheet(isPresented: $showEditPatientView){
            EditPatientView(patients: patients, patient: patient)
        }
        .onAppear{self.getPatientNotes(patientId: patient.id)}
        
        Spacer()
    }
}

struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView(patients: PatientsViewModel(), notes: NotesViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()))
    }
}
