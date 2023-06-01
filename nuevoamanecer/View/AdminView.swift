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
    @State private var resetFilters = false // Botón de reseteo
    
    // Variables para rastrear si los botones de filtro han sido presionados
    @State private var communicationStyleFilterTapped = false
    @State private var cognitiveLevelFilterTapped = false
    
    // Variable para rastrear si se ha seleccionado un filtro
    @State private var communicationStyleFilterSelected = false
    @State private var cognitiveLevelFilterSelected = false
    
    //opciones de comunicación y nivel cognitivo
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
    

    // Filtrado
    private func resetSearchFilters() {
        filteredPatients = []
        selectedCommunicationStyle = ""
        selectedCognitiveLevel = ""
        search = ""
        resetFilters = false
        communicationStyleFilterTapped = false
        cognitiveLevelFilterTapped = false
        communicationStyleFilterSelected = false
        cognitiveLevelFilterSelected = false
    }
    
    //Busqueda por nombre o apellido
    private func performSearchByName(keyword: String){
        filteredPatients = patientsListDisplayed.filter{ patient in
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

            return firstNameMatch || lastNameMatch
        }
    }

    
    //Busqueda por estilo de comunicación
    private func performSearchByCommunicationStyle(){
            filteredPatients = patientsListDisplayed.filter{ patient in
                patient.communicationStyle == selectedCommunicationStyle
            }
        }
    
    //Busqueda por nivel cognitivo
    private func performSearchByCognitiveLevel(){
        filteredPatients = patientsListDisplayed.filter{ patient in
            patient.cognitiveLevel == selectedCognitiveLevel
        }
    }
    
    //muestra de pacientes
    private var patientsListDisplayed: [Patient] {
        filteredPatients.isEmpty ? patients.patientsList : filteredPatients
    }
    
    var body: some View {
        NavigationStack{
                 VStack{
                     
                         // Barra de busqueda y agregar niño
                         HStack {
                             TextField("Buscar niño", text: $search)
                                 .padding()
                                 .background(Color.white)
                                 .cornerRadius(10)
                                 .overlay(
                                     RoundedRectangle(cornerRadius: 10)
                                         .stroke(Color.gray, lineWidth: 1)
                                 )
                                 //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                 .frame(width: UIScreen.main.bounds.width / 4)
                                 .padding()
                                 .onChange(of: search, perform: performSearchByName)
                             
                             // Botones de Filtrado
                             Spacer()
                             
                             //Boton para añadir paciente
                             Button(action: {
                                 showAddPatient.toggle()
                             }) {
                                 HStack {
                                     Image(systemName: "plus.circle.fill")
                                     Text("Agregar Niño")
                                 }
                                
                             }
                             .padding(.horizontal)
                             .padding(.vertical, 10)
                             .background(Color.blue)
                             .foregroundColor(.white)
                             .cornerRadius(10)
                         }
                         .padding(.horizontal, 50)
                         .padding(.bottom)
                     
                     // Botones de filtrado
                     HStack{
                         // Estilo de comunicación
                         if communicationStyleFilterTapped {
                             Picker("Comunicación", selection: $selectedCommunicationStyle) {
                                 ForEach(communicationStyles, id: \.self) {
                                     Text($0)
                                 }
                             }
                             .disabled(communicationStyleFilterSelected)
                             .onChange(of: selectedCommunicationStyle, perform: { value in
                                 performSearchByCommunicationStyle()
                                 if selectedCommunicationStyle != "" {
                                     communicationStyleFilterSelected = true
                                 }
                             })
                             .pickerStyle(MenuPickerStyle())
                             .padding()
                             .background(Color.white)
                             .cornerRadius(10)
                             //.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                         } else {
                             Text("Communication Style")
                                 .font(.system(size: 16, weight: .regular))
                                 .foregroundColor(Color.blue)
                                 .padding()
                                 .background(Color.white)
                                 .cornerRadius(10)
                                 .onTapGesture {
                                     communicationStyleFilterTapped = true
                                 }
                         }

                         // Nivel cognitivo
                         if cognitiveLevelFilterTapped {
                             Picker("Nivel Cognitivo", selection: $selectedCognitiveLevel) {
                                 ForEach(cognitiveLevels, id: \.self) {
                                     Text($0)
                                 }
                             }
                             .disabled(cognitiveLevelFilterSelected)
                             .onChange(of: selectedCognitiveLevel, perform: { value in
                                 performSearchByCognitiveLevel()
                                 if selectedCognitiveLevel != "" {
                                     cognitiveLevelFilterSelected = true
                                 }
                             })
                             .pickerStyle(MenuPickerStyle())
                             .padding()
                             .background(Color.white)
                             .cornerRadius(10)
                             //.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                         } else {
                             Text("Cognitive Level")
                                 .font(.system(size: 16, weight: .regular))
                                 .foregroundColor(Color.blue)
                                 .padding()
                                 .background(Color.white)
                                 .cornerRadius(10)
                                 .onTapGesture {
                                     cognitiveLevelFilterTapped = true
                                 }
                         }

                         Button(action: {
                             resetFilters = true
                         }) {
                             Text("Resetear Filtros")
                                 .font(.system(size: 16, weight: .regular))
                                 .foregroundColor(Color.white)
                                 .padding()
                                 .background(Color.blue)
                                 .cornerRadius(10)
                         }
                         .onChange(of: resetFilters, perform: { value in
                             if value {
                                 resetSearchFilters()
                             }
                         })
                         
                         Spacer()
                     }
                     .padding(.horizontal, 50)
                     .padding(.bottom)

                         
                     
                     //lista de pacientes
                     List(patientsListDisplayed, id:\.id){ patient in
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
                        
                        HStack(alignment: .center){
                            Text("Grupo " + patient.group)
                                .font(.subheadline)
                                .padding(.trailing)
                                .padding(.vertical,5)
                            Text("Nivel Cognitivo " + patient.cognitiveLevel)
                                .font(.subheadline)
                                .padding(.trailing)
                                .padding(.vertical,5)
                            Text("Comunicación " + patient.communicationStyle)
                                .font(.subheadline)
                                .padding(.trailing)
                                .padding(.vertical,5)
                        }
                        .padding(.top)
                    }
                    
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
    
