//
//  AddPatientView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 22/05/23.
//

import SwiftUI
import FirebaseStorage


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
    @State private var upload_image: UIImage?
    
    @State private var showAlert = false
    
    @State private var storage = FirebaseAlmacenamiento()
    
    @State private var shouldShowImagePicker = false
    @State private var imageURL = URL(string: "")
    
    @State private var uploadPatient: Bool = false
    
    func loadImageFromFirebase(name:String) {
        let storageRef = Storage.storage().reference(withPath: name)
        
        storageRef.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            self.imageURL = url!
        }
    }

    
    
    var body: some View {

      /*
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
      */
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
                            
                            //Subir imagen a firestore
                            if let thisImage = self.upload_image {
                                storage.uploadImage(image: thisImage, name: lastName + firstName + "profile_picture")
                            } else {
                                print("No se pudo subir imagen, no se selecciono ninguna")
                            }
                            
                            //Generar URl para la imagen del niño
                            loadImageFromFirebase(name: lastName + firstName + "profile_picture.jpg")
                             
                            //debug
                            print(imageURL?.absoluteString ?? "ERROR")
                            
                            //Checar que datos son validos
                            if(firstName != "" && lastName != "" && group != "" && communicationStyleSelector != "" && congnitiveLevelSelector != ""){
                                
                                uploadPatient.toggle()
                                dismiss()
                                 
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
            //.navigationTitle("Agregar Niño")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
            //.navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $upload_image)
            }
        }
        .onDisappear {
            
            if(uploadPatient) {
                let patient = Patient(id: UUID().uuidString ,firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyleSelector, cognitiveLevel: congnitiveLevelSelector, image: imageURL?.absoluteString ?? "placeholder", notes: [String]())
               patients.addData(patient: patient){ error in
                   if error != "OK" {
                       print(error)
                   }else{
                       Task {
                           if let patientsList = await patients.getData(){
                               DispatchQueue.main.async {
                                   self.patients.patientsList = patientsList
                               }
                           }
                       }
                   }
               }
            }
        }
    }
}

struct AddPatientView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatientView(patients: PatientsViewModel())
    }
}
