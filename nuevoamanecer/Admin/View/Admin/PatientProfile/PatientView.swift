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
    @StateObject var users = AuthViewModel()
    
    
    //patient
    let patient: Patient
    
    
    //showViews
    @State var showAddNoteView = false
    @State var showEditPatientView = false
    @State private var showDeleteNoteAlert = false
    @State var showEditNoteView = false
    
    //Note Selection
    @State private var selectedNoteIndex: Int?
    @State var selectedNoteToEdit: Note?
    //= Note(id: "", patientId: "", order: 0, title: "", text: "")
        
    @State private var showCommunicatorMenu: Bool = false
    
    @State private var selection: String? = nil
    
    @EnvironmentObject var pathWrapper: NavigationPathWrapper
    
    //obtiene edad del paciente
    private func getAge(patient: Patient) -> Int {
        let birthday: Date = patient.birthDate // tu fecha de nacimiento aquí
        let calendar: Calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year!
        
        return age
    }
    
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
        VStack {
            //user header

                
            HStack {
                VStack{
                    if(patient.image == "placeholder") {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.trailing)
                    } else {
                        KFImage(URL(string: patient.image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
                
                VStack(alignment: .leading) {
                    
                    HStack{
                        Text(patient.firstName + " " + patient.lastName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.black)
                            .padding(.vertical, 1)
                        
                        Text(String(getAge(patient: patient)) + " años")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(Color.gray)
                            .padding(.vertical, 1)
                        
                    }
                    
                    
                    Text("Grupo: " + patient.group)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.black)
                        .padding(.vertical, 1)
                    
                    // Add other patient details here
                    Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.black)
                        .padding(.vertical, 1)
                    
                    // Add other patient details here
                    Text("Comunicación: " + patient.communicationStyle)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.black)
                        .padding(.vertical, 2)
                }
                Spacer()
                
                
                
                VStack{
                    
                    HStack{
                        Spacer()
                        // validar que el usuario sea admin para mostrar
                        if (users.user?.isAdmin == true) {
                            Button(action: {
                                // Handle settings action here
                                showEditPatientView.toggle()
                                
                            }) {
                                HStack{
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("Editar Perfil")
                                }
                                .padding(10)
                                .frame(width: 157, height: 40)
                        }
                        }
                    }
                    .padding(.bottom)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        
                        Spacer()
                        
                        Menu {
                            // validar que el usuario sea admin para mostrar
                            if (users.user?.isAdmin == true) {
                                Button {
                                    pathWrapper.push(data: NavigationDestination(viewType: .userPictogramEditor, id: patient.id))
                                } label: {
                                    Text("Editar comunicador de \(patient.firstName)")
                                    Image(systemName: "pencil")
                                }
                            }
                            
                            Button {
                                pathWrapper.push(data: NavigationDestination(viewType: .doubleCommunicator, id: patient.id))
                            } label: {
                                Text("Acceder a comunicador de \(patient.firstName)")
                                Image(systemName: "message.fill")
                            }
                            
                            Button {
                                pathWrapper.push(data: NavigationDestination(viewType: .album, id: patient.id))
                            } label: {
                                Text("Acceder a album de \(patient.firstName)")
                                Image(systemName: "message.fill")
                            }
                            
                        } label: {
                            HStack {
                                Image(systemName: "ellipsis.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Comunicador de \(patient.firstName)")
                                    .font(.headline)
                            }
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(20)
            .padding(.horizontal, 50)
            Spacer()
                

            //.frame(maxHeight: 210)
            //.background(.red)
            
            Divider()
            
            //notes
            HStack{
            // 1/4 of the screen for the notes list
                VStack {
                    
                    
                    HStack{
                        Spacer()
                        Text("Expediente")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(10)
                     
                    
                    //Add note button
                    HStack{
                        Button(action: {
                            showAddNoteView.toggle()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Agregar Nota")
                                
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 10)

                    
                    //checamos si hay notas
                    if(notes.notesList.count == 0){
                        
                        List{
                            HStack{
                                
                                Spacer() // Espacio superior
                                Text("Aquí podrás ver el orden de tus notas")
                                    .foregroundColor(Color.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer() // Espacio inferior
                                 
                            }
                        }
                        .listStyle(.sidebar)
                        
                    }else{
                        List(notes.notesList, id: \.id) { note in
                            Text(note.title)
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(Color.black)
                                .frame(minHeight: 50)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .listStyle(.sidebar)
                        .padding(.top)
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 4)
                .background(Color.white.opacity(0.1))
                //.background(Color.red)
                
                Divider()
                // 3/4 of the screen for patient information and notes
                VStack {

                    //Checamos que existan pacientes
                    if(notes.notesList.count == 0){
                        List{
                            HStack{
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("Agrega, ordena y edita las notas del expediente")
                                        .font(.title2)
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("Deja presionada una nota para mover su order y deslizala hacía la izquierda para editarla o eliminarla")
                                        .font(.headline)
                                        .foregroundColor(Color.gray)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding()
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            .padding(.top, 20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding([.leading, .trailing, .bottom, .top], 10)
                        }
                        .listStyle(.inset)
                    }else{
                        //Lista de pacientes
                        List {
                            ForEach(Array(notes.notesList.enumerated()), id: \.element.id) { index, note in
                                
                                //Tarjeta paciente
                                NoteCardView(note: note)
                                .frame(minHeight: 150)
                                .padding([.top, .bottom], 5)
                                .swipeActions(edge: .trailing) {
                                    // validar que el usuario sea admin para mostrar
                                    if (users.user?.isAdmin == true) {
                                        Button {
                                            //selectedNote = note
                                            selectedNoteIndex = index
                                            showDeleteNoteAlert = true
                                            
                                        } label: {
                                            Label("Eliminar", systemImage: "trash")
                                        }
                                        .tint(.red)
                                        .padding()
                                        
                                        Button {
                                            // Aquí va la lógica para actualizar la nota
                                            selectedNoteToEdit = note
                                            showEditNoteView = true
                                            
                                        } label: {
                                            Label("Editar", systemImage: "pencil")
                                        }
                                        .tint(.blue)
                                        .padding()
                                    }
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
                                          //self.selectedNote = nil
                                      },
                                      secondaryButton: .cancel {
                                          // Cancelar eliminación
                                          self.selectedNoteIndex = nil
                                          //self.selectedNote = nil
                                      }
                                )
                            }
                        }
                        .listStyle(.inset)
                    }
                    

                }
            }
            .padding([.bottom, .trailing, .leading])
            
        }
        .sheet(isPresented: $showAddNoteView) {
            AddNoteView(notes: notes, patient: patient)
        }
        .sheet(item: $selectedNoteToEdit){ note in
            EditNoteView(notes: notes, note: note)
        }
        .sheet(isPresented: $showEditPatientView){
            EditPatientView(patients: patients, patient: patient)
        }
        .sheet(isPresented: $showCommunicatorMenu){
            CommunicatorMenuView(patient:patient)
        }
        .onAppear{
            self.getPatientNotes(patientId: patient.id)
        }
        
        Spacer()
    }
}

struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        PatientView(patients: PatientsViewModel(), notes: NotesViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String](), identificador: ""))
    }
}
