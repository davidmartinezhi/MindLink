//
//  AddPatientView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 22/05/23.
//

import SwiftUI
struct AddPatientView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var patients : PatientsViewModel
    

    var cognitiveLevels = ["Alto", "Medio", "Bajo"]
    @State private var congnitiveLevelSelector = ""
    
    var communicationStyles = ["Verbal", "No-verbal", "Mixto"]
    @State private var communicationStyleSelector = ""
    
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var birthDate: Date = Date()
    @State private var group : String = ""
    @State private var image : String = ""
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Agregar Niño")
                .font(.largeTitle)
                .padding()
            
            Form {
                //section for photo
                
                Section(header: Text("Información del Paciente")) {
                    TextField("Primer Nombre", text: $firstName)
                    TextField("Apellidos", text: $lastName)
                    TextField("Grupo", text: $group)
                    DatePicker("Fecha de nacimiento", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                Section(header: Text("Nivel Cognitivo")) {
                    Picker("Nivel Cognitivo", selection: $congnitiveLevelSelector) {
                        ForEach(cognitiveLevels, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Estilo de Comunicación")) {
                    Picker("Tipo de comunicación", selection: $communicationStyleSelector) {
                        ForEach(communicationStyles, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    
                    //botón de crear usuario
                    Button("Agregar Niño"){
                        //Checar que datos son validos
                        if(firstName != "" && lastName != "" && group != "" && communicationStyleSelector != "" && congnitiveLevelSelector != ""){
                            let patient = Patient(id: UUID().uuidString ,firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyleSelector, cognitiveLevel: congnitiveLevelSelector, image: "http://github.com/davidmartinezhi.png", notes: [String]())
                                patients.addData(patient: patient){ error in
                                if error != "OK" {
                                    print(error)
                                }else{
                                    
                                    Task {
                                        if let patientsList = await patients.getData(){
                                            DispatchQueue.main.async {
                                                self.patients.patientsList = patientsList
                                                dismiss()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            showAlert = true
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .alert("Todos los campos deben ser llenados", isPresented: $showAlert){
                        Button("Ok") {}
                    }
                    message: {
                        Text("Asegurate de haber llenado todos los campos requeridos")
                    }
                    
                    //botón de cancelar
                    Button("Cancelar"){
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                }
            }
            .padding()
        }
        .navigationTitle("Agregar Paciente")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddPatientView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatientView(patients: PatientsViewModel())
    }
}
