//
//  PatientView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI
import Kingfisher

struct PatientView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var currentUser: UserWrapper
    @EnvironmentObject var navPath: NavigationPathWrapper
    
    //ViewModels
    @ObservedObject var patients : PatientsViewModel
    @ObservedObject var notes : NotesViewModel
    @StateObject var auth = AuthViewModel()
    
    //patient
    @State var patient: Patient
    @State var search: String = ""
    @State private var filteredNotes: [Note] = []
    
    //tags
    let tags: [String] = ["Información Personal","Contacto","Historial Médico","Diagnóstico","Tratamiento","Soporte Familiar","Consentimientos","Otro"]
    @State private var selectedTag: String = ""
    @State private var tagSelected: Bool = false
    
    //showViews
    @State var showAddNoteView: Bool = false
    @State var showEditPatientView: Bool = false
    @State private var showDeleteNoteAlert: Bool = false
    @State var showEditNoteView: Bool = false
    
    //Note Selection
    @State private var selectedNoteIndex: Int?
    @State var selectedNoteToEdit: Note?
    //= Note(id: "", patientId: "", order: 0, title: "", text: "")
    
    @State private var showCommunicatorMenu: Bool = false
    
    @State private var selection: String? = nil
    
    init(patients: PatientsViewModel, notes: NotesViewModel, patient: Patient) {
        self.patients = patients
        self.notes = notes
        self._patient = State(initialValue: patient)
    }
        
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
                    self.filteredNotes = self.notes.notesList
                }
            }
        }
    }
    
    
    func moveNote(from source: IndexSet, to destinationIdx: Int) {
        guard let sourceIdx: Int = source.first else { return }
        let adjustDestination: Bool = destinationIdx > sourceIdx
                
        notes.notesList.moveItem(from: notes.notesList.firstIndex(of: filteredNotes[sourceIdx])!,
                                 to: notes.notesList.firstIndex(of: filteredNotes[destinationIdx - (adjustDestination ? 1 : 0)])!)
        filteredNotes.moveItem(from: sourceIdx, to: destinationIdx - (adjustDestination ? 1 : 0))

        // Considerar: el valor de 'order' de los elementos de filteredNotes no es actualizado.
        for i in 0..<notes.notesList.count {
            if notes.notesList[i].order != i {
                notes.notesList[i].order = i
                self.notes.updateData(note: notes.notesList[i]) { response in // utilizar batches
                    if response != "OK" {
                        print("Error al actualizar la nota \(notes.notesList[i].id): \(response)")
                    }
                }
            }
        }
    }
    
    private func filterNotesByTag() {
        if !selectedTag.isEmpty {
            filteredNotes = notes.notesList.filter { note in
                note.tag == selectedTag
            }
        } else {
            filteredNotes = notes.notesList  // Restablecer a todas las notas si no se selecciona ninguna etiqueta
        }
    }
    
    private func performSearchByText(key: String) {
        // Si el filtro de búsqueda está vacío, regresa todas las notas
        if(search == ""){
            filteredNotes = notes.notesList
        }
        
        let searchingWithFilters = notes.notesList
        
        // Convierte la búsqueda a una forma que ignora los diacríticos
        let keyFolding = key.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        
        // Si hay un filtro de búsqueda, regresa las notas filtradas
        filteredNotes = searchingWithFilters.filter { note in
            // Convierte el título y el contenido de la nota a una forma que ignora los diacríticos
            let titleFolding = note.title.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            let textFolding = note.text.folding(options: .diacriticInsensitive, locale: .current).lowercased()
            
            // Convierte la búsqueda a minúsculas
            let keyFolding = key.folding(options: .diacriticInsensitive, locale: .current).lowercased()

            // Busca la cadena de búsqueda en el título y el contenido
            let titleMatch = titleFolding.hasPrefix(keyFolding)
            let textMatch = textFolding.contains(keyFolding)
            
            return titleMatch || textMatch
        }
        
        //return filteredNotes.isEmpty ? nil : filteredNotes
    }
    
    
    var body: some View {
        GeometryReader { geometry in  // Agrega GeometryReader
            VStack {
                //user header
                HStack {
                    VStack {
                        if(patient.image == "placeholder") {
                            ImagePlaceholderView(firstName: patient.firstName, lastName: patient.lastName)
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
                                .font(.headline)
                                .foregroundColor(Color.gray)
                                .padding(.vertical, 1)
                        }
                        
                        Text("Grupo: " + patient.group)
                            .font(.subheadline)
                            //.foregroundColor(Color.gray)
                            .padding(.vertical, 1)
                        
                        // Add other patient details here
                        Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                            .font(.subheadline)
                            //.foregroundColor(Color.gray)
                            .padding(.vertical, 1)
                        
                        // Add other patient details here
                        Text("Comunicación: " + patient.communicationStyle)
                            .font(.subheadline)
                            //.foregroundColor(Color.gray)
                            .padding(.vertical, 2)
                    }
                    
                    Spacer()
                    
                    VStack{
                        
                        HStack{
                            Spacer()
                            // validar que el usuario sea admin para mostrar
                            if currentUser.isAdmin! {
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
                            
                            if currentUser.isAdmin!{
                                Menu {
                                    // validar que el usuario sea admin para mostrar
                                    if currentUser.isAdmin! {
                                        Button {
                                            navPath.push(NavigationDestination<PictogramEditor>(content: PictogramEditor(patient: patient)))
                                        } label: {
                                            Text("Editar comunicador de \(patient.firstName)")
                                            Image(systemName: "pencil")
                                        }
                                    }
                                    
                                    Button {
                                        navPath.push(NavigationDestination<DoubleCommunicator>(content: DoubleCommunicator(patient: patient)))
                                    } label: {
                                        Text("Acceder a comunicador de \(patient.firstName)")
                                        Image(systemName: "message.fill")
                                    }
                                    
                                    /*
                                    Button {
                                        pathWrapper.push(data: NavigationDestination(viewType: .album, userId: patient.id))
                                    } label: {
                                        Text("Acceder a album de \(patient.firstName)")
                                        Image(systemName: "message.fill")
                                    }
                                     */
                                    
                                } label: {
                                    HStack {
                                        Image(systemName: "ellipsis.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text("Comunicador de \(patient.firstName)")
                                            .font(.headline)
                                    }
                                    .padding(10)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                            }else{
                                Button(action: {
                                    // Handle settings action here
                                    navPath.push(NavigationDestination<DoubleCommunicator>(content: DoubleCommunicator(patient: patient)))
                                }) {
                                    HStack{
                                        Image(systemName: "message.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text("Comunicador de \(patient.firstName)")
                                    }
                                    .padding(10)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    //.padding(10)
                                    //.frame(width: 157, height: 40)
                            }
                            }
                        }
                    }
                }
                .padding(10)
                .padding(.horizontal, 50)
                .padding(.bottom, 20)
                Spacer()
                    
                
                Divider()
                
                //notes
                HStack{
                // 1/4 of the screen for the notes list
                    VStack {
                        
                        //Add note button
                                HStack{
                                    Button(action: {
                                        showAddNoteView.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                            Text("Agregar Nota")
                                        }
                                        .frame(width: geometry.size.width / 6)
                                    }
                                }
                                .padding(.vertical, 15)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                        
                        
                        SearchBarView(searchText: $search, placeholder: "Buscar nota", searchBarWidth: geometry.size.width / 6)
                            .onChange(of: search, perform: performSearchByText)
                            .padding(.bottom, 10)
                            .padding(.top, 15)
                        
                        ZStack {
                            Picker("Filtrar Etiquetas", selection: $selectedTag) {
                                if !tagSelected {
                                    Text("Filtrar Etiquetas").tag("")
                                        .foregroundColor(.white)
                                }else{
                                    Text("Eliminar filtro").tag("")
                                }
                                
                                
                                ForEach(tags, id: \.self) {
                                    Text($0)
                                }
                            }
                            .foregroundColor(
                                selectedTag == "Información Personal" ? Color.orange :
                                selectedTag == "Contacto" ? Color.red :
                                selectedTag == "Historial Médico" ? Color.pink :
                                selectedTag == "Diagnóstico" ? Color.purple :
                                selectedTag == "Tratamiento" ? Color.yellow :
                                selectedTag == "Soporte Familiar" ? Color.cyan :
                                selectedTag == "Consentimientos" ? Color.green :
                                selectedTag == "Contacto" ? Color.teal :
                                selectedTag == "Otro" ? Color.black : Color.blue
                            )
                            .onChange(of: selectedTag, perform: { value in
                                filterNotesByTag()
                                tagSelected = selectedTag != "" && selectedTag != "Eliminar filtro"
                            })
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: geometry.size.width / 6)

                            if tagSelected {
                                Button(action: {
                                    selectedTag = ""
                                    tagSelected = false
                                }) {
                                    HStack {
                                    }
                                }
                                .background(.white)
                                .cornerRadius(10)
                            }
                        }
                        .frame(minWidth: geometry.size.width / 6)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                        HStack{
                        }
                        .frame(width:  geometry.size.width / 4, height: 15)
                        .background(
                            selectedTag == "Información Personal" ? Color.orange :
                            selectedTag == "Contacto" ? Color.red :
                            selectedTag == "Historial Médico" ? Color.pink :
                            selectedTag == "Diagnóstico" ? Color.purple :
                            selectedTag == "Tratamiento" ? Color.yellow :
                            selectedTag == "Soporte Familiar" ? Color.cyan :
                            selectedTag == "Consentimientos" ? Color.green :
                            selectedTag == "Contacto" ? Color.teal :
                            selectedTag == "Otro" ? Color.black : Color.clear
                        )
                        
                        //checamos si hay notas
                        if (filteredNotes.count == 0){
                            
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
                            List(filteredNotes, id: \.id) { note in
                                
                                Button(action:{selectedNoteIndex = notes.notesList.firstIndex(where: { $0.id == note.id })}){
                                    HStack{
                                            
                                        Text(note.title)
                                            .font(.system(size: 18, weight: .light))
                                            .foregroundColor(selectedNoteIndex == notes.notesList.firstIndex(where: { $0.id == note.id }) ? Color.blue : Color.black)
                                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .leading)
                                            //.frame(width: geometry.size.width / 5, alignment: .leading)
                                        
                                        Circle()
                                            .frame(minHeight: 7, maxHeight: 10)
                                            .foregroundColor(
                                                note.tag == "Información Personal" ? Color.orange :
                                                    note.tag == "Contacto" ? Color.red :
                                                    note.tag == "Historial Médico" ? Color.pink :
                                                    note.tag == "Diagnóstico" ? Color.purple :
                                                    note.tag == "Tratamiento" ? Color.yellow :
                                                    note.tag == "Soporte Familiar" ? Color.cyan :
                                                    note.tag == "Consentimientos" ? Color.green :
                                                    note.tag == "Contacto" ? Color.teal :
                                                    note.tag == "Otro" ? Color.black : Color.clear
                                            )
                                    }

                    
                                }
                            }
                            //.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listStyle(.sidebar)
                            
                        }
                    }
                    //.frame(width: UIScreen.main.bounds.width / 4)
                    .frame(width: geometry.size.width / 4)
                    .background(Color.white.opacity(0.1))
                    //.background(Color.red)
                    
                    Divider()
                    // 3/4 of the screen for patient information and notes
                    VStack {

                        //Checamos que existan pacientes
                        if(filteredNotes.count == 0){
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
                                        Text("Deja presionada una nota para mover su orden y deslízala hacía la izquierda para editarla o eliminarla")
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
                            /*
                            HStack{
                                Spacer() // Espacio superior
                                Text("Deja presionada una nota para reordenar y deslizala hacía la izquierda para editar o eliminar")
                                    .foregroundColor(Color.white)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer() // Espacio inferior
                            }
                            .background(Color(.systemGray2))
                            .frame(minHeight: 30)
                             */
                            
                            ScrollViewReader { proxy in
                                List {
                                    ForEach(Array(filteredNotes.enumerated()), id: \.element.id) { index, note in
                                        
                                        //Tarjeta paciente
                                        NoteCardView(note: note)
                                        .frame(minHeight: 150)
                                        .padding([.top, .bottom], 5)
                                        .swipeActions(edge: .trailing) {
                                            // validar que el usuario sea admin para mostrar
                                            if currentUser.isAdmin! {
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
                                    .onChange(of: selectedNoteIndex) { newIndex in
                                        if let newIndex = newIndex {
                                            let noteId = notes.notesList[newIndex].id
                                            proxy.scrollTo(noteId, anchor: .top)
                                        }
                                    }
                                    .padding(.top)
                                    .alert(isPresented: $showDeleteNoteAlert) {
                                        Alert(title: Text("Eliminar Nota"),
                                              message: Text("¿Estás seguro de que quieres eliminar esta nota? Esta acción no se puede deshacer."),
                                              primaryButton: .destructive(Text("Eliminar")) {
                                                  // Confirmar eliminación
                                                  if let index = self.selectedNoteIndex {
                                                      let noteId = notes.notesList[index].id
                                                      let patientId = notes.notesList[index].patientId
                                                      
                                                      notes.deleteData(noteId: noteId) { response in
                                                          if response == "OK" {
                                                              search = ""
                                                              notes.notesList.remove(atOffsets: IndexSet(integer: index))
                                                              filteredNotes.remove(atOffsets: IndexSet(integer: index))
                                                              Task{
                                                                  if let notesList = await notes.getDataById(patientId: patientId){
                                                                      DispatchQueue.main.async{
                                                                          self.notes.notesList = notesList.sorted { $0.order < $1.order }
                                                                          self.filteredNotes = self.notes.notesList
                                                                      }
                                                                  }
                                                              }
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
                            } //ScrollViewReader
                        }
                    }
                    
                }
                .padding([.bottom, .trailing, .leading])
                
            }
            .sheet(isPresented: $showAddNoteView) {
                AddNoteView(notes: notes, filteredNotes: $filteredNotes, search: $search, patient: patient)
            }
            .sheet(item: $selectedNoteToEdit){ note in
                EditNoteView(notes: notes, filteredNotes: $filteredNotes, note: note)
            }
            .sheet(isPresented: $showEditPatientView){
                EditPatientView(patients: patients, patient: $patient)
            }
            .sheet(isPresented: $showCommunicatorMenu){
                CommunicatorMenuView(patient:patient)
            }
        }
        .onAppear {
            self.getPatientNotes(patientId: patient.id)
        }
        
        Spacer()
    }
}
