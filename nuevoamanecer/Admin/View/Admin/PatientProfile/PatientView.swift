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
    @State var search: String = ""
    @State private var filteredNotes: [Note] = []

    
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
                    self.filteredNotes = self.notes.notesList
                }
            }
        }
    }
    
    /*
    func moveNote(from source: IndexSet, to destination: Int) {
        
        
        // Realiza el movimiento de las notas
        self.notes.notesList.move(fromOffsets: source, toOffset: destination)
        self.filteredNotes.move(fromOffsets: source, toOffset: destination)

        // Actualizar el orden de las notas en la base de datos
        for (index, note) in self.notes.notesList.enumerated() {
            // Creamos una copia de la nota para no modificar la original
            var updatedNote = note
            updatedNote.order = index
            // Actualizamos la nota en la base de datos
            self.notes.updateData(note: updatedNote) { response in
                if response != "OK" {
                    // Aquí puedes manejar el error si lo deseas
                    print("Error al actualizar la nota \(updatedNote.id): \(response)")
                }
            }
        }
        
        self.filteredNotes = self.notes.notesList
        
        // Vuelve a aplicar el filtro si es necesario
        if !search.isEmpty {
            performSearchByText(key: search)
        }
    }*/
    
    func moveNoteAlt3(from source: IndexSet, to destinationIdx: Int) {        
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
    
    func moveNoteAlt2(from source: IndexSet, to destination: Int) {
        // Obtener el índice de origen y la nota que se va a mover

        guard let sourceIdx = source.first else { return }
        let movingNote = self.notes.notesList[sourceIdx]
        
        guard let destinationIdx = self.notes.notesList.firstIndex(where: { $0.id == self.filteredNotes[destination].id }) else {
            print("Nota de destino no encontrada en notesList.")
            return
        }
        
        // Caso 1: Si el índice de destino es menor que el de origen
        if destinationIdx < sourceIdx {
            var start = 0
            if(destinationIdx > start){start = destinationIdx}
            
            for i in (start...sourceIdx).reversed() {
                self.notes.notesList[i] = self.notes.notesList[i - 1]
            }
            
            self.notes.notesList[start] = movingNote
        }
        
        // Caso 2: Si el índice de destino es mayor que el de origen
        if destinationIdx > sourceIdx {
            var end = self.notes.notesList.count-1
            if(destinationIdx < self.notes.notesList.count-1){
                end = destinationIdx
            }
            for i in sourceIdx...end {
                self.notes.notesList[i] = self.notes.notesList[i + 1]
                //[1,2,4,4,5,6]
            }
            
            self.notes.notesList[end] = movingNote
        }
        
        self.filteredNotes = self.notes.notesList
        
        // Actualizar el orden en las notas
        for (index, var note) in notes.notesList.enumerated() {
            note.order = index
            self.notes.updateData(note: note) { response in
                if response != "OK" {
                    print("Error al actualizar la nota \(note.id): \(response)")
                }
            }
        }
        
        if !self.search.isEmpty {
            self.performSearchByText(key: self.search)
        }
        
    }



    
    // Función para mover una nota de una posición a otra
    func moveNoteAlt(from source: IndexSet, to destination: Int) {
        /*
         Puede servir el crear un algoritmo para que se recorran, hacer manual la nueva asignación de notas
         [id1, id2, id3, id4]
         quiero mover id2 al 4
         [id1,id3, id4, id2] todos los numeros antes del destination fueron recorridos 1 hacía la derecha
         
         [id1, id2, id3, id4]
         quiero mover id3 al 1
         [id3, id2, id1, id4] todos los numeros antes del destination deben de recorrerse 1 hacia la izquierda
         
         si el destination idx es menor al source idx, en ese caso todas las notas a la derecha de destination (incluido) en el array serán recorridos i+1 y se coloca en destination el source
         si el destination idx es mayor al source idx, en ese caso todos las notas a la izquierda de destination (incluido) en el array se recorren i-1 y se coloca en destination el source
         
         
         También para editar usuario puede funcionar el crear una función que actualice toda la lista despues
         y vuelva a aplicar filtro
         
         Igual para añadir usuario
         
         */
        
        
        // Si hay un filtro aplicado, actualizamos el orden en la lista original.
        if (search != ""){
            
            // Obtenemos la nota de origen y destino en la lista filtrada
            let sourceNote = self.filteredNotes[source.first!]
            let adjustedDestination = min(destination, self.filteredNotes.count - 1)
            let destinationNote = self.filteredNotes[adjustedDestination]
            
            // Buscamos los índices de las notas de origen y destino en la lista original
            if let sourceIndex = self.notes.notesList.firstIndex(where: { $0.id == sourceNote.id }),
               let destinationIndex = self.notes.notesList.firstIndex(where: { $0.id == destinationNote.id }) {
                
                // Creamos una copia de la nota que se moverá y actualizamos su orden
                var movedNote = self.notes.notesList[sourceIndex]
                movedNote.order = destinationIndex
                
                // Actualizamos la nota en la lista original
                self.notes.notesList[sourceIndex] = movedNote
                
                // Recorremos todas las notas para actualizar su orden
                for (index, note) in self.notes.notesList.enumerated() {
                    var updatedNote = note
                    // Si la nota no es la que se movió, actualizamos su orden
                    if updatedNote.id != movedNote.id {
                        updatedNote.order = index
                    }
                    // Actualizamos la nota en la base de datos
                    self.notes.updateData(note: updatedNote) { response in
                        if response != "OK" {
                            // Manejo de errores
                            print("Error al actualizar la nota \(updatedNote.id): \(response)")
                        }
                    }
                }
                
                self.filteredNotes = self.notes.notesList
                
            }
        }else {
            // Si no hay un filtro aplicado, el comportamiento es el mismo que antes.
            self.notes.notesList.move(fromOffsets: source, toOffset: destination)
            self.filteredNotes.move(fromOffsets: source, toOffset: destination)

            for (index, note) in self.notes.notesList.enumerated() {
                var updatedNote = note
                updatedNote.order = index
                self.notes.updateData(note: updatedNote) { response in
                    if response != "OK" {
                        print("Error al actualizar la nota \(updatedNote.id): \(response)")
                    }
                }
            }
        }
    }




    
    func moveNote(from source: IndexSet, to destination: Int) {
        // Primero, sincronizamos la lista de notas filtradas con la lista de notas original.
        self.filteredNotes = self.notes.notesList
        
        // Realizamos el movimiento de las notas en la lista original.
        self.notes.notesList.move(fromOffsets: source, toOffset: destination)
        
        // Realizamos el movimiento de las notas en la lista filtrada.
        self.filteredNotes.move(fromOffsets: source, toOffset: destination)
        
        // Recorremos la lista de notas original para actualizar el orden en la base de datos.
        for (index, note) in self.notes.notesList.enumerated() {
            // Creamos una copia de la nota para no modificar la original.
            var updatedNote = note
            
            // Actualizamos el campo 'order' de la nota con su nuevo índice.
            updatedNote.order = index
            
            // Actualizamos la nota en la base de datos.
            self.notes.updateData(note: updatedNote) { response in
                // Verificamos si la actualización fue exitosa.
                if response != "OK" {
                    // Si hay un error, lo imprimimos en la consola.
                    print("Error al actualizar la nota \(updatedNote.id): \(response)")
                }
            }
        }
        
        // Si hay un texto de búsqueda (filtro) aplicado, volvemos a aplicar el filtro.
        if !search.isEmpty {
            performSearchByText(key: search)
        }
    }



    
    /*
    //Move notes and save order in database
    func moveNote(from source: IndexSet, to destination: Int) {
        
        self.notes.notesList.move(fromOffsets: source, toOffset: destination)
        //self.filteredNotes.move(fromOffsets: source, toOffset: destination)
        //self.notesListDisplayed.move(fromOffsets: source, toOffset: destination)
        


        // Actualizar el orden de las notas en la base de datos
        for (index, note) in self.notes.notesList.enumerated() {
            // Creamos una copia de la nota para no modificar la original
            var updatedNote = note
            updatedNote.order = index - 1
            // Actualizamos la nota en la base de datos
            self.notes.updateData(note: updatedNote) { response in
                if response != "OK" {
                    // Aquí puedes manejar el error si lo deseas
                    print("Error al actualizar la nota \(updatedNote.id): \(response)")
                }
            }
        }
        
        // Reaplicar el filtro
        performSearchByText(key: search)
    }
     */
    
    private func performSearchByText(key: String) {
        // Si el filtro de búsqueda está vacío, regresa todas las notas
        if(search == ""){
            filteredNotes = notes.notesList
        }
        
        let searchingWithFilters = notes.notesList
        
        // Si hay un filtro de búsqueda, regresa las notas filtradas
        filteredNotes = searchingWithFilters.filter { note in
            // Convierte el título y el contenido de la nota a minúsculas
            let titleLowercased = note.title.lowercased()
            let textLowercased = note.text.lowercased()
            
            // Convierte la búsqueda a minúsculas
            let keyLowercased = key.lowercased()

            // Busca la cadena de búsqueda en el título y el contenido
            let titleMatch = titleLowercased.hasPrefix(keyLowercased)
            let textMatch = textLowercased.contains(keyLowercased)

            return titleMatch || textMatch
        }
        
        //return filteredNotes.isEmpty ? nil : filteredNotes
    }
    
    
    var body: some View {
        GeometryReader { geometry in  // Agrega GeometryReader
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
                                        pathWrapper.push(data: NavigationDestination(viewType: .userPictogramEditor, patient: patient))
                                    } label: {
                                        Text("Editar comunicador de \(patient.firstName)")
                                        Image(systemName: "pencil")
                                    }
                                }
                                
                                Button {
                                    pathWrapper.push(data: NavigationDestination(viewType: .doubleCommunicator, patient: patient))
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
                .padding(10)
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
                                .frame(width: geometry.size.width / 6)
                            }
                        }
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        
                        
                        SearchBarView(searchText: $search, placeholder: "Buscar nota", searchBarWidth: geometry.size.width / 6)
                            .onChange(of: search, perform: performSearchByText)

                        
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
                            List(filteredNotes, id: \.id) { note in
                                Button(action: {}) {
                                   
                                    Text(note.title)
                                        .font(.system(size: 18, weight: .light))
                                        .foregroundColor(selectedNoteIndex == notes.notesList.firstIndex(where: { $0.id == note.id }) ? Color.blue : Color.black)
                                    
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .leading)
                                .onTapGesture {
                                    selectedNoteIndex = notes.notesList.firstIndex(where: { $0.id == note.id })
                                }
                            }
                            //.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listStyle(.sidebar)
                            .padding(.top)
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
                            
                            ScrollViewReader { proxy in
                                List {
                                    ForEach(Array(filteredNotes.enumerated()), id: \.element.id) { index, note in
                                        
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
                                                    selectedNoteToEdit = note
                                                    showEditNoteView = true
                                                    
                                                } label: {
                                                    Label("Editar", systemImage: "pencil")
                                                }
                                                .tint(.blue)
                                                .padding()
                                            }
                                        }
                                        /*
                                        .onDrag {
                                            // Elimina el filtro cuando el usuario comienza a arrastrar
                                            search = ""
                                            performSearchByText(key: search)
                                            //self.filteredNotes = self.notes.notesList
                                            return NSItemProvider(object: note.title as NSString)
                                        }
                                         */
                                         
                                    }
                                    .onMove(perform: moveNoteAlt3)
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
                EditNoteView(notes: notes, filteredNotes: $filteredNotes, note: note, search: $search)
            }
            .sheet(isPresented: $showEditPatientView){
                EditPatientView(patients: patients, patient: patient)
            }
            .sheet(isPresented: $showCommunicatorMenu){
                CommunicatorMenuView(patient:patient)
            }
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
