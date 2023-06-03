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

            return firstNameMatch || lastNameMatch || patient.group.lowercased().hasPrefix(keyword.lowercased())
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

                return firstNameMatch || lastNameMatch || patient.group.lowercased().hasPrefix(search.lowercased())
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

                return firstNameMatch || lastNameMatch || patient.group.lowercased().hasPrefix(search.lowercased())
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
        NavigationStack{
                 VStack{
                     
                     //Boton para agregar niños
                     HStack{
                         Spacer()
                         //Boton para añadir paciente
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
                             .padding([.horizontal, .vertical], 10)
                             
                         }
                         
                         .background(Color.blue)
                         .foregroundColor(Color.white)
                         .cornerRadius(10)
                     }
                     .padding(.horizontal, 50)
                     //.padding(.vertical)
                     
                     // Filtrado
                     HStack{
                         
                         Text("Filtrado")
                             .font(.system(size: 24, weight: .bold))
                             .foregroundColor(Color.gray)
                         
                         
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
                             .onChange(of: resetFilters, perform: { value in
                                 if value {
                                     resetSearchFilters()
                                 }
                             })
                         }
                         Spacer()
                     }
                     .padding(.horizontal, 50)
                     .padding(.top, 10)
                     
                     // Barra de busqueda
                     HStack {
                         HStack{
                             Image(systemName: "magnifyingglass")
                                 .resizable()
                                 .frame(width: 20, height: 20)
                                 .foregroundColor(Color.gray)
                                 .padding()
                             TextField("Buscar niño o grupo", text: $search)
                                 .padding()
                                 .onChange(of: search, perform: performSearchByName)
                                  
                         }
                         .cornerRadius(10) // Asegúrate de que este está aquí
                         .background(Color(.systemGray6))
                         .clipShape(RoundedRectangle(cornerRadius: 10)) // Añade esta línea

                         Spacer()
                              
                     }
                     .padding(.horizontal, 50)
                     .padding([.bottom, .top], 20)
                     

                         
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
                             PatientCard(patient: patient)
                                 .padding()
                                 .background(Color.white)
                                 .cornerRadius(10)
                                 //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                 .padding([.leading, .trailing, .bottom], 10)
                                 .background(NavigationLink("", destination: PatientView(patients: patients, notes: notes, patient:patient)).opacity(0))
                         }
                         .listStyle(.automatic)
                         .sheet(isPresented: $showAddPatient) {
                             AddPatientView(patients:patients)
                         }
                     }
                 }
             }
        }
    }
    
    struct PatientCard: View {
        
        let patient: Patient
        
        var body: some View{
            VStack(alignment: .leading) {
                HStack {
                    KFImage(URL(string: patient.image))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    //.overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    //.cornerRadius(16.0)
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text(patient.firstName + " " + patient.lastName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        VStack(alignment: .leading){
                            Text("Grupo: " + patient.group)
                                .font(.headline)
                                .foregroundColor(Color.gray)
                                .padding(.trailing)
                                .padding(.vertical,5)
                            Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                                .font(.headline)
                                .foregroundColor(Color.gray)
                                .padding(.trailing)
                                .padding(.vertical,5)
                            Text("Comunicación: " + patient.communicationStyle)
                                .font(.headline)
                                .foregroundColor(Color.gray)
                                .padding(.trailing)
                                .padding(.vertical,5)
                        }
                        
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
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
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 5)
        }
    }
    

    struct AdminView_Previews: PreviewProvider {
        static var previews: some View {
            AdminView()
        }
    }
    
