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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var cognitiveLevels = ["Alto", "Medio", "Bajo"]
    @State private var congnitiveLevelSelector = ""
    
    var communicationStyles = ["Verbal", "No-verbal", "Mixto"]
    @State private var communicationStyleSelector = ""
    
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var birthDate : Date = Date.now
    @State private var group : String = ""
    @State private var upload_image: UIImage?
    
    @State private var showAlert = false
    
    @State private var storage = FirebaseAlmacenamiento()
    
    @State private var shouldShowImagePicker = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    //Imagen del niño
                    if let displayImage = self.upload_image {
                        Image(uiImage: displayImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(128)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 83))
                            .padding()
                            .foregroundColor(Color(.label))
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 64)
                    .stroke(Color.black, lineWidth: 3))
                
                Form {
                    Section(header: Text("Información del Paciente")) {
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
                    
                    Section(header: Text("Foto de perfil")) {
                        Button() {
                            shouldShowImagePicker.toggle()
                        } label: {
                            Text("Seleccionar imagen")
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
                            //Subir imagen a firestore
                            if let thisImage = self.upload_image {
                                storage.uploadImage(image: thisImage, name: lastName + firstName + "profile_picture")
                            } else {
                                print("No se pudo subir imagen, no se selecciono ninguna")
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
            //.navigationTitle("Agregar Niño")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
            //.navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $upload_image)
            }
        }
    }
}

struct AddPatientView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatientView(patients: PatientsViewModel())
    }
}
