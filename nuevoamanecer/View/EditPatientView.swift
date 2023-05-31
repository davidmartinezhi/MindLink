//
//  EditPatientView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 26/05/23.
//

import SwiftUI

struct EditPatientView: View {
    @ObservedObject var patients: PatientsViewModel
    @State var patient: Patient
    @Environment(\.dismiss) var dismiss

    
    var cognitiveLevels = ["Alto", "Medio", "Bajo"]
    @State private var congnitiveLevelSelector = ""
    
    var communicationStyles = ["Verbal", "No-verbal", "Mixto"]
    @State private var communicationStyleSelector = ""
    
    @State var showAlert : Bool = false
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var birthDate : Date = Date.now
    @State private var group : String = ""
    @State private var image : String = ""
    
    
    
    func initializeData(patient: Patient) -> Void{
        firstName = patient.firstName
        lastName = patient.lastName
        birthDate = patient.birthDate
        group = patient.group
        image = patient.image
        communicationStyleSelector = patient.communicationStyle
        congnitiveLevelSelector = patient.cognitiveLevel
    }
    
    
    var body: some View {
        VStack {
            HStack{
               
                
                Text("Editar Información")
                    .font(.largeTitle)
                    .padding()
                Spacer()
               
                
                //Delete patient
                DeletePatientView(patients:patients, patient:patient)
            }
            .padding()

            
            Form {
                Section(header: Text("Información")) {
                    TextField("Primer Nombre", text: $firstName)
                    TextField("Apellidos", text: $lastName)
                    TextField("Grupo", text: $group)
                    DatePicker("Fecha de nacimiento", selection: $birthDate, displayedComponents: .date)
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
                    
                    //botón de guardar usuario editadp
                    Button("Guardar"){
                        
                        //Checar que datos son validos
                        if(firstName != "" && lastName != "" && group != "" && communicationStyleSelector != "" && congnitiveLevelSelector != ""){
                            let patient = Patient(id: patient.id ,firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyleSelector, cognitiveLevel: congnitiveLevelSelector, image: "http://github.com/davidmartinezhi.png", notes: [String]())
                            
                            //call method for update
                            patients.updateData(patient: patient){ error in
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
            .onAppear{
                initializeData(patient: patient)
            }
            
        }



        //.navigationTitle("Agregar Paciente")
        //.navigationBarTitleDisplayMode(.inline)
    }
    
}



struct EditPatientView_Previews: PreviewProvider {
    static var previews: some View {
        EditPatientView(patients: PatientsViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()))
    }
}
