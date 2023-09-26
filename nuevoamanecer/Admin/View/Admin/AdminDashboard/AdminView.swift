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
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var currentUser: UserWrapper
    @EnvironmentObject var navPath: NavigationPathWrapper
    
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
        
    @State private var selection: String? = nil
        
    @State private var showAdminView: Bool = false
    @State private var showRegisterView: Bool = false
    var hiddenNavBar : Bool = false

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

    private var patientsListDisplayed: [Patient]? {
        if communicationStyleFilterSelected || cognitiveLevelFilterSelected || search != "" {
            return filteredPatients.isEmpty ? nil : filteredPatients
        }
        return patients.patientsList
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
    
    var body: some View {
        VStack{
    
            VStack {

                AdminNav(showAdminView: $showAdminView, showRegisterView: $showRegisterView)
                
                //Search bar y Boton para agregar pacientes
                HStack{
                    // magnifyingglass
                    SearchBarView(searchText: $search, placeholder: "Buscar paciente o grupo", searchBarWidth: 250)
                        .onChange(of: search, perform: performSearchByName)
                    
                    Spacer()
                    //Boton para añadir paciente
                    if currentUser.isAdmin! {
                        Button(action: {
                            showAddPatient.toggle()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Agregar Paciente")
                            }
                        }
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    HStack{
                        
                        Menu {
                            
                            if currentUser.isAdmin! {
                                Button {
                                    navPath.push(NavigationDestination<PictogramEditor>(content: PictogramEditor(patient: nil)))
                                } label: {
                                    Text("Editar comunicador base")
                                    Image(systemName: "pencil")
                            }
                            }
                            
                            Button {
                                navPath.push(NavigationDestination<SingleCommunicator>(content: SingleCommunicator(patient: nil)))
                            } label: {
                                Text("Acceder a comunicador base")
                                Image(systemName: "message.fill")
                            }
                        } label: {
                            HStack {
                                Image(systemName: "ellipsis.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Comunicador base")
                            }
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 10)
                //.padding(.vertical)
                
                
                // Filtrado
                HStack{
                    
                    Text("Filtrado")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.gray)
                        .padding(.trailing)
                    
                    Divider()
                    
                    HStack {
                        // Nivel cognitivo
                        ZStack {
                            Picker("Nivel Cognitivo", selection: $selectedCognitiveLevel) {
                                if !cognitiveLevelFilterSelected {
                                    Text("Nivel Cognitivo")
                                        .foregroundColor(Color.black)
                                }
                                ForEach(cognitiveLevels, id: \.self) {
                                    Text($0)
                                }
                            }
                            .onChange(of: selectedCognitiveLevel, perform: { value in
                                performSearchByCognitiveLevel()
                                cognitiveLevelFilterSelected = selectedCognitiveLevel != "" && selectedCognitiveLevel != "Nivel Cognitivo"
                            })
                            .disabled(cognitiveLevelFilterSelected) // Deshabilita el Picker si el filtro está seleccionado
                            .pickerStyle(.menu)
                            .frame(width: 157, height: 40)
                            .cornerRadius(10)

                            // Botón para restablecer el filtro de nivel cognitivo
                            if cognitiveLevelFilterSelected {
                                Button(action: {
                                    selectedCognitiveLevel = ""
                                    cognitiveLevelFilterSelected = false
                                }) {
                                    HStack{
                                        Text("Cognición " + selectedCognitiveLevel.prefix(selectedCognitiveLevel.count - 1) + "a")
                                            .foregroundColor(.blue)
                                        Image(systemName: "xmark.circle")
                                            .foregroundColor(.red)
                                    }
                                }
                                .frame(width: 157, height: 40)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.leading)

                        // Comunicación
                        ZStack {
                            Picker("Comunicación", selection: $selectedCommunicationStyle) {
                                if !communicationStyleFilterSelected {
                                    Text("Comunicación")
                                        .foregroundColor(Color.black)
                                }
                                ForEach(communicationStyles, id: \.self) {
                                    Text($0)
                                }
                            }
                            .onChange(of: selectedCommunicationStyle, perform: { value in
                                performSearchByCommunicationStyle()
                                communicationStyleFilterSelected = selectedCommunicationStyle != "" && selectedCommunicationStyle != "Comunicación"
                            })
                            .disabled(communicationStyleFilterSelected) // Deshabilita el Picker si el filtro está seleccionado
                            .pickerStyle(.menu)
                            .frame(width: 150, height: 40)
                            .cornerRadius(10)

                            // Botón para restablecer el filtro de comunicación
                            if communicationStyleFilterSelected {
                                Button(action: {
                                    selectedCommunicationStyle = ""
                                    communicationStyleFilterSelected = false
                                }) {
                                    HStack{
                                        Text("Comunicación " + selectedCommunicationStyle)
                                            .foregroundColor(.blue)
                                        Image(systemName: "xmark.circle")
                                            .foregroundColor(.red)
                                    }

                                }
                                .frame(width: 220, height: 40)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.trailing)
                    }

                    /*
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
                     
                     */
                    Spacer()
                }
                .frame(maxHeight: 50)
                .padding(.horizontal, 50)
                .padding(.bottom, 10)
                    
                //mostramos que no existe pacientes con los filtros seleccionados
                if(patientsListDisplayed == nil){
                    
                    if(patients.patientsList.count == 0){
                        List{
                            HStack{
                                Spacer()
                                VStack {
                                    Text("Aún no hay pacientes")
                                        .font(.title2)
                                        .foregroundColor(Color.gray)
                                        .padding()
                                    Text("Los pacientes que agregues se mostrarán en esta pantalla :)")
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
                        .onChange(of: patients.patientsList, perform: {value in
                            resetSearchFilters()
                        })
                        .sheet(isPresented: $showAddPatient) {
                            AddPatientView(patients:patients)
                        }
                    }
                    else{
                        List{
                            HStack{
                                Spacer() // Espacio superior
                                Text("No se han encontrado pacientes con ese filtrado.")
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
                        .onChange(of: patients.patientsList, perform: {value in
                            resetSearchFilters()
                        })
                        .sheet(isPresented: $showAddPatient) {
                            AddPatientView(patients: patients)
                        }
                        
                    }
                    Spacer()
                }
                else{
                    //mostramos lista de pacientes
                    List(patientsListDisplayed ?? patients.patientsList, id:\.id){ patient in
                        
                        ZStack(alignment: .trailing) {
                            PatientCardView(patient: patient)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding([.leading, .trailing, .bottom], 10)
                                .contentShape(Rectangle()) // Importante para detectar toques en toda el área
                                .onTapGesture {
                                    navPath.push(NavigationDestination<PatientView>(content: PatientView(patients: patients, notes: notes, patient: patient)))
                                }
                            
                            Button {
                                navPath.push(NavigationDestination<DoubleCommunicator>(content: DoubleCommunicator(patient: patient)))
                            } label: {
                                Text("Comunicador")
                                    .padding(10)
                                    .padding([.leading, .trailing], 15)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.trailing, 20)
                        }
                    }
                    .listStyle(.automatic)
                    .onChange(of: patients.patientsList, perform: {value in
                        resetSearchFilters()
                    })
                    .sheet(isPresented: $showAddPatient) {
                        AddPatientView(patients:patients)
                    }
                    .sheet(isPresented: $showAdminMenu){
                        AdminMenuView(user: currentUser.getUser()!)
                    }
                }
            }
        }
        .sheet(isPresented: $showAdminView){
            AdminMenuView(user: currentUser.getUser()!)
        }
        .sheet(isPresented: $showRegisterView){
            RegisterView()
        }
        .navigationBarBackButtonHidden(true)
    }
}
    
