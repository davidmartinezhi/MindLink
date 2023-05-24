//
//  AdminView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI
import Kingfisher


struct AdminView: View {
    
    //Pacientes
    @StateObject var patients = PatientsViewModel()
    
    
    //Agregar paciente
    @State private var showAddPatient = false
    
    //Filtrado de Pacientes
    @State var search: String = ""
    @State private var filteredPatients: [Patient] = []
    
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

    
    
    //Busqueda por nombre o apellido
    private func performSearchByName(keyword: String){
        filteredPatients = patients.patientsList.filter{ patient in
            patient.firstName.lowercased().hasPrefix(keyword.lowercased()) ||
            patient.lastName.lowercased().hasPrefix(keyword.lowercased())
        }
    }
    
    //Busqueda por estilo de comunicación
    private func performSearchByCommunicationStyle(keyword: String){
        if(filteredPatients.isEmpty){
            filteredPatients = patients.patientsList.filter{ patient in
                patient.communicationStyle == keyword
            }
        }else{
            filteredPatients = filteredPatients.filter{ patient in
                patient.communicationStyle == keyword
            }
        }
    }
    
    //Busqueda por nivel cognitivo
    private func performSearchByCognitiveLevel(keyword: String){

        if(filteredPatients.isEmpty){
            filteredPatients = patients.patientsList.filter{ patient in
                patient.cognitiveLevel == keyword
            }
        }else{
            filteredPatients = filteredPatients.filter{ patient in
                patient.cognitiveLevel == keyword
            }
        }
    }
    
    //muestra de pacientes
    private var patientsListDisplayed: [Patient] {
        filteredPatients.isEmpty ? patients.patientsList : filteredPatients
    }
    
    var body: some View {
        NavigationStack{
                 VStack{
                     
                     // Barra de busqueda
                     HStack {
                         TextField("Buscar niño", text: $search)
                             .textFieldStyle(.roundedBorder)
                             .onChange(of: search, perform: performSearchByName)
                             .padding()

                     }
                     .padding(.horizontal, 50)
                     
                     
                     // Botones de Filtrado
                     HStack{
                         
                         
                         Spacer()
                         
                         //Add patient
                         Button(action: {
                             showAddPatient.toggle()
                         }) {
                             Text("Agregar niño")
                            
                         }
                         .padding(.horizontal)
                         .padding(.vertical, 10)
                         .background(Color.blue)
                         .foregroundColor(.white)
                         .cornerRadius(10)
                     }
                     .padding(.horizontal, 50)
                     .padding(.bottom)
                     

                     List(patientsListDisplayed, id:\.id){ patient in
                         PatientCard(patient: patient)
                     }
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
                            .font(.title2)
                            .bold()
                        
                        HStack{
                            Text("Grupo: " + patient.group)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(patient.communicationStyle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
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
                }
                .padding(.horizontal)
            }
            //.background(Color(.systemGray6))
            //.cornerRadius(10)
            //.shadow(radius: 5)
            .padding(.vertical, 5)
        }
    }
    

    struct AdminView_Previews: PreviewProvider {
        static var previews: some View {
            AdminView()
        }
    }
    
