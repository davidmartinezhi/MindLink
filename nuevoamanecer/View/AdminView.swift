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
            //let firstNameString = str.components(separatedBy: ", ")
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
                             .padding()
                             .background(Color.white)
                             .cornerRadius(10)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color.gray, lineWidth: 1)
                             )
                             //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                             .padding()
                             .onChange(of: search, perform: performSearchByName)
                     }
                     .padding(.horizontal, 30)
                     
                     
                     // Botones
                     HStack{
                         
                         // Botones de Filtrado
                         Spacer()
                         
                         //Add patient
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
                     
/*
                     List(patientsListDisplayed, id:\.id){ patient in
                         NavigationLink {
                             PatientView(patient: patient)
                         } label: {
                             PatientCard(patient: patient)
                         }
  
                         
                     }
 */
                     List(patientsListDisplayed, id:\.id){ patient in
                         PatientCard(patient: patient)
                             .padding()
                             .background(Color.white)
                             .cornerRadius(10)
                             //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                             .padding([.leading, .trailing, .bottom], 10)
                             .background(NavigationLink("", destination: PatientView(patient:patient, notes: notes, patients: patients)).opacity(0))
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
    
