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
    @State var showAddNoteView = false
    @State var showEditPatientView = false
    @State var selectedNote: Note?
    @ObservedObject var notes : NotesViewModel
    @ObservedObject var patients : PatientsViewModel
    
    
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
                
                
                List(notes.notesList, id:\.id){ note in
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
                            }
                            Spacer()
                        }
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], 15)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding([.top, .bottom], 5)
                }
                .padding(.top)
                .listStyle(.inset)
            }
            
        }
        .sheet(isPresented: $showAddNoteView) {
            AddNoteView(notes: notes, patient: patient)
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
        PatientView(patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()), notes: NotesViewModel(), patients: PatientsViewModel())
    }
}
