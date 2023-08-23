//
//  AdminView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI
import Kingfisher


struct AdminView: View {
    
    //Modelo pacientes y notas
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject var users = AuthViewModel()
    @StateObject var patients = PatientsViewModel()
    @StateObject var notes = NotesViewModel()
    
    //Agregar paciente
    @State private var showAddPatient = false
    
    //Filtrado de Pacientes
    @State var search: String = ""
    @State private var filteredPatients: [Patient] = []
    @State private var resetFilters = false
    
    // Variable para rastrear si se ha seleccionado un filtro
    @State private var communicationStyleFilterSelected = false
    @State private var cognitiveLevelFilterSelected = false
    
    //opciones de comunicación y nivel cognitivo para filtros
    var communicationStyles = ["Verbal", "No-verbal", "Mixto"]
    var cognitiveLevels = ["Alto", "Medio", "Bajo"]
    
    //mostrar opciones de filtrado
    @State private var showCognitiveLevelFilterOptions = false
    @State private var showCommunicationStyleFilterOptions = false
    
    //Selección de filtrados
    @State private var selectedCommunicationStyle = ""
    @State private var selectedCognitiveLevel = ""
    
    //Selección de filtrados
    @State private var showSelectedCommunicationStyle = false
    @State private var showSelectedCognitiveLevel = false
    
    //Hidden NavBar
    @State private var showAdminMenu = false
    
    var user: User
    
    @State private var selection: String? = nil
        
    @State private var showAdminView: Bool = false
    @State private var showRegisterView: Bool = false
    var hiddenNavBar : Bool = false
    
    @StateObject var pathWrapper = NavigationPathWrapper() // Contiene una instancia de NavigationPath, es proveida como variable de ambiente. 

    //Reseteo de filtrado
    // Filtrado
    private func resetSearchFilters() {
        filteredPatients = []
        selectedCommunicationStyle = ""
        selectedCognitiveLevel = ""
        search = ""
        resetFilters = false
        communicationStyleFilterSelected = false
        cognitiveLevelFilterSelected = false
    }
    
    //Busqueda por nombre o apellido
    private func performSearchByName(keyword: String){
        
        var searchingWithFilters = patients.patientsList
        
        if(communicationStyleFilterSelected){
            searchingWithFilters = searchingWithFilters.filter{ patient in
                    patient.communicationStyle == selectedCommunicationStyle
                }
        }
        
        if(cognitiveLevelFilterSelected){
            searchingWithFilters = searchingWithFilters.filter{ patient in
                patient.cognitiveLevel == selectedCognitiveLevel
            }
        }
        
        filteredPatients = searchingWithFilters.filter{ patient in
            let firstAndLastName = patient.firstName + " " + patient.lastName
            let firstAndLastNameComponent = firstAndLastName.lowercased()
            let firstNameComponents = patient.firstName.lowercased().split(separator: " ")
            let lastNameComponents = patient.lastName.lowercased().split(separator: " ")
            
            
            var firstNameMatch = false
            var lastNameMatch = false

            // Busca en cada componente de firstName
            for component in firstNameComponents {
                if component.hasPrefix(keyword.lowercased()) {
                    firstNameMatch = true
                    break
                }
            }

            // Busca en cada componente de lastName
            for component in lastNameComponents {
                if component.hasPrefix(keyword.lowercased()) {
                    lastNameMatch = true
                    break
                }
            }

            return firstNameMatch || lastNameMatch || patient.group.lowercased().hasPrefix(keyword.lowercased()) || firstAndLastNameComponent.hasPrefix(keyword.lowercased())
        }
    }
    
    //Busqueda por estilo de comunicación
    private func performSearchByCommunicationStyle(){
        
        var searchingWithFilters = patients.patientsList
        
        //filtramos nivel cognitivo
        if(cognitiveLevelFilterSelected){
            searchingWithFilters = searchingWithFilters.filter{ patient in
                patient.cognitiveLevel == selectedCognitiveLevel
            }
        }
        
        //filtramos por busqueda en search bar
        if(search != ""){
            searchingWithFilters = searchingWithFilters.filter{ patient in
                let firstAndLastName = patient.firstName + " " + patient.lastName
                let firstAndLastNameComponent = firstAndLastName.lowercased()
                let firstNameComponents = patient.firstName.lowercased().split(separator: " ")
                let lastNameComponents = patient.lastName.lowercased().split(separator: " ")
                
                var firstNameMatch = false
                var lastNameMatch = false

                // Busca en cada componente de firstName
                for component in firstNameComponents {
                    if component.hasPrefix(search.lowercased()) {
                        firstNameMatch = true
                        break
                    }
                }

                // Busca en cada componente de lastName
                for component in lastNameComponents {
                    if component.hasPrefix(search.lowercased()) {
                        lastNameMatch = true
                        break
                    }
                }

                return firstNameMatch || lastNameMatch || patient.group.lowercased().hasPrefix(search.lowercased()) || firstAndLastNameComponent.hasPrefix(search.lowercased())
            }
        }
        
        //si no es valida la operación, no filramos
        if(selectedCommunicationStyle == "" || selectedCommunicationStyle == "Comunicación"){
            filteredPatients = searchingWithFilters
        }
        //si es valida la operación, filramos
        else{
            filteredPatients = searchingWithFilters.filter{ patient in
                    patient.communicationStyle == selectedCommunicationStyle
            }
        }
    }
    
    //Busqueda por nivel cognitivo
    private func performSearchByCognitiveLevel(){
        
        var searchingWithFilters = patients.patientsList

        //filtramos estilo de comunicación
        if(communicationStyleFilterSelected){
            searchingWithFilters = searchingWithFilters.filter{ patient in
                    patient.communicationStyle == selectedCommunicationStyle
                }
        }
        
        //filtramos por palabras en el searchbar
        if(search != ""){
            searchingWithFilters = searchingWithFilters.filter{ patient in
                let firstAndLastName = patient.firstName + " " + patient.lastName
                let firstAndLastNameComponent = firstAndLastName.lowercased()
                let firstNameComponents = patient.firstName.lowercased().split(separator: " ")
                let lastNameComponents = patient.lastName.lowercased().split(separator: " ")
                
                var firstNameMatch = false
                var lastNameMatch = false

                // Busca en cada componente de firstName
                for component in firstNameComponents {
                    if component.hasPrefix(search.lowercased()) {
                        firstNameMatch = true
                        break
                    }
                }

                // Busca en cada componente de lastName
                for component in lastNameComponents {
                    if component.hasPrefix(search.lowercased()) {
                        lastNameMatch = true
                        break
                    }
                }

                return firstNameMatch || lastNameMatch || patient.group.lowercased().hasPrefix(search.lowercased()) || firstAndLastNameComponent.hasPrefix(search.lowercased())
            }
        }
        
        //checamos si es valida la operación
        if(selectedCognitiveLevel == "" || selectedCognitiveLevel == "Nivel Cognitivo"){
            filteredPatients = searchingWithFilters
        }else{
            filteredPatients = searchingWithFilters.filter{ patient in
                patient.cognitiveLevel == selectedCognitiveLevel
            }
        }
        
    }
    
    //Lista de pacientes mostrada al usuario
    /*
    private var patientsListDisplayed: [Patient] {
        filteredPatients.isEmpty ? patients.patientsList : filteredPatients
    }
     */
    
    private var patientsListDisplayed: [Patient]? {
        if communicationStyleFilterSelected || cognitiveLevelFilterSelected || search != "" {
            return filteredPatients.isEmpty ? nil : filteredPatients
        }
        return patients.patientsList
    }
    
    var body: some View {
        VStack{
            NavigationStack(path: $pathWrapper.path){
                        VStack{

                            AdminNav(authViewModel: AuthViewModel(), showAdminView: $showAdminView, showRegisterView: $showRegisterView, user: user)
                            
                            //Search bar y Boton para agregar niños
                            HStack{
                                
                                //Search Bar
                                HStack{
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color.gray)
                                        .padding([.top, .bottom, .leading])
                                    TextField("Buscar niño o grupo", text: $search)
                                        .padding([.top, .bottom, .trailing])
                                        .onChange(of: search, perform: performSearchByName)
                                        
                                }
                                .frame(width: 250)
                                .cornerRadius(10) // Asegúrate de que este está aquí
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10)) // Añade esta línea
                                
                                Spacer()
                                //Boton para añadir paciente
                                if (users.user?.isAdmin == true) {
                                    Button(action: {
                                        showAddPatient.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text("Agregar Niño")
                                                .font(.headline)
                                        }
                                    }
                                    .padding(10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                
                                HStack{
                                    
                                    Menu {
                                        
                                        if (users.user?.isAdmin == true) {
                                            Button {
                                                pathWrapper.push(data: NavigationDestination(viewType: .basePictogramEditor))
                                            } label: {
                                                Text("Editar comunicador base")
                                                Image(systemName: "pencil")
                                        }
                                        }
                                        
                                        Button {
                                            pathWrapper.push(data: NavigationDestination(viewType: .singleCommunicator))
                                        } label: {
                                            Text("Acceder a comunicador base")
                                            Image(systemName: "message.fill")
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "ellipsis.circle")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text("Comunicador base")
                                                .font(.headline)
                                        }
                                        .padding(10)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                    .navigationDestination(for: NavigationDestination.self) { destination in
                                        switch destination.viewType {
                                        case .singleCommunicator:
                                            SingleCommunicator(pictoCollectionPath: "basePictograms", catCollectionPath: "baseCategories")
                                        case .doubleCommunicator:
                                            DoubleCommunicator(pictoCollectionPath1: "basePictograms", catCollectionPath1: "baseCategories", pictoCollectionPath2: "User/\(destination.id))/pictograms", catCollectionPath2: "User/\(destination.id)/categories")
                                        case .basePictogramEditor:
                                            PictogramEditor(pictoCollectionPath: "basePictograms", catCollectionPath: "baseCategories")
                                        case .userPictogramEditor:
                                            PictogramEditor(pictoCollectionPath: "User/\(destination.id)/pictograms", catCollectionPath: "User/\(destination.id)/categories")
                                        default:
                                            Album(patientId: destination.id)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            //.padding(.vertical)
                            
                            
                            // Filtrado
                            HStack{
                                
                                Text("Filtrado")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color.gray)
                                    .padding(.trailing)
                                
                                Divider()
                                
                                
                                //Nivel cognitivo
                                Picker("Nivel Cognitivo", selection: $selectedCognitiveLevel) {
                                    if(!cognitiveLevelFilterSelected){
                                        Text("Nivel Cognitivo")
                                            .foregroundColor(Color.black)
                                    }
                                    ForEach(cognitiveLevels, id: \.self) {
                                        Text($0)
                                    }
                                    
                                }
                                .onChange(of: selectedCognitiveLevel, perform: { value in
                                    performSearchByCognitiveLevel()
                                    if selectedCognitiveLevel != "" && selectedCognitiveLevel != "Nivel Cognitivo" {
                                        cognitiveLevelFilterSelected = true
                                    }else {
                                        //reseteamos valores cognitive level
                                        cognitiveLevelFilterSelected = false
                                    }
                                })
                                .frame(width: 157, height: 40)
                                .pickerStyle(.menu)
                                .padding(.leading)
                                .cornerRadius(10)
                                
                                //Comunicación
                                Picker("Comunicación", selection: $selectedCommunicationStyle) {
                                    if(!communicationStyleFilterSelected){
                                        Text("Comunicación")

                                    }
                                    ForEach(communicationStyles, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .onChange(of: selectedCommunicationStyle, perform: { value in
                                    performSearchByCommunicationStyle()
                                    if selectedCommunicationStyle != "" && selectedCommunicationStyle != "Comunicación" {
                                        communicationStyleFilterSelected = true
                                    }else {
                                        //reseteamos valores cognitive level
                                        communicationStyleFilterSelected = false
                                    }
                                })
                                .frame(width: 150, height: 40)
                                .pickerStyle(.menu)
                                .padding(.trailing)
                                .cornerRadius(10)
                
                                
                                if(communicationStyleFilterSelected || cognitiveLevelFilterSelected){
                                    //reset filters
                                    Button(action: {
                                        resetFilters = true
                                    }) {
                                        Text("Resetear")
                                    }
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .onChange(of: resetFilters, perform: { value in
                                        if value {
                                            resetSearchFilters()
                                        }
                                    })
                                }
                                Spacer()
                            }
                            .frame(maxHeight: 50)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 70)

                            

                                
                            //mostramos que no hay pacientes con los filtros seleccionados
                            
                            if(patientsListDisplayed == nil){
                                
                                if(patients.patientsList.count == 0){
                                    List{
                                        HStack{
                                            Spacer()
                                            VStack {
                                                Text("Aún no hay niños")
                                                    .font(.title2)
                                                    .foregroundColor(Color.gray)
                                                    .padding()
                                                Text("Los niños que agregues se mostrarán en esta pantalla :)")
                                                    .font(.headline)
                                                    .foregroundColor(Color.gray)
                                            }
                                            //.padding(.top, 150)
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding([.leading, .trailing, .bottom, .top], 10)
                                    }
                                    .listStyle(.automatic)
                                }
                                else{
                                    List{
                                        HStack{
                                            Spacer() // Espacio superior
                                            Text("No se han encontrado niños con ese filtrado.")
                                                .font(.title2)
                                                .foregroundColor(Color.gray)
                                            Spacer() // Espacio inferior
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding([.leading, .trailing, .bottom, .top], 10)
                                    }
                                    //.background(Color.gray.opacity(0.1))
                                    .listStyle(.automatic)
                                    
                                }
                                Spacer()
                            }
                            else{
                                //mostramos lista de pacientes
                                List(patientsListDisplayed ?? patients.patientsList, id:\.id){ patient in
                                    NavigationLink(value: patient){
                                        PatientCardView(patient: patient)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                            .padding([.leading, .trailing, .bottom], 10)
                                            //.background(NavigationLink("", destination: PatientView(patients: patients, notes: notes, patient:patient)).opacity(0))
                                    }
                                    

                                }
                                .navigationDestination(for: Patient.self, destination: { patient in
                                    PatientView(patients: patients, notes: notes, patient: patient)
                                })
                                .listStyle(.automatic)
                                .onChange(of: patients.patientsList, perform: {value in
                                    resetSearchFilters()
                                })
                                .sheet(isPresented: $showAddPatient) {
                                    AddPatientView(patients:patients)
                                }
                                .sheet(isPresented: $showAdminMenu){
                                    AdminMenuView(authViewModel: authViewModel, user: user)
                                }
                            }
                        }
                    }

        }
            .sheet(isPresented: $showAdminView){
                AdminMenuView(authViewModel: authViewModel, user: user)
            }
            .sheet(isPresented: $showRegisterView){
                RegisterView(authViewModel: authViewModel)
            }
            .environmentObject(pathWrapper)
        }
    }
    
    

    struct AdminView_Previews: PreviewProvider {
        static var previews: some View {
            AdminView(authViewModel: AuthViewModel(), user: User(id: "", name: "", email: "", isAdmin: false, image: ""))
        }
    }
    
