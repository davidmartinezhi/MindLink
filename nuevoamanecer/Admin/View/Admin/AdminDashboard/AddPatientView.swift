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
    
    let patientId = UUID().uuidString
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
    
    @State var isSaving : Bool = false
    
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
        
        VStack{
            
            //Imagen del niño
            VStack{
                Button() {
                    shouldShowImagePicker.toggle()
                } label: {
                    if let displayImage = self.upload_image {
                        Image(uiImage: displayImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(128)
                            .padding(.horizontal, 20)
                    } else {
                        ZStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 100))
                                //.foregroundColor(Color(.label))
                                .foregroundColor(.gray)
                                

                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 25))
                                .offset(x: 35, y: 40)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 20)
                        
                    }
                }
                //Spacer()
            }
            .frame(maxHeight: 150)
            //.padding(.top, 50)
            
            
            //Form
            VStack{
                Form {
                    Section(header: Text("Información del Paciente")) {
                        TextField("Primer Nombre", text: $firstName)
                        TextField("Apellidos", text: $lastName)
                        TextField("Grupo", text: $group)
                        DatePicker("Fecha de nacimiento", selection: $birthDate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("Nivel Cognitivo")) {
                        Picker("Nivel Cognitivo", selection: $congnitiveLevelSelector) {
                            Text("")
                            ForEach(cognitiveLevels, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    Section(header: Text("Estilo de Comunicación")) {
                        Picker("Tipo de comunicación", selection: $communicationStyleSelector) {
                            Text("")
                            ForEach(communicationStyles, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
            }
            
            //Buttons
            
            //VStack(alignment: .leading, spacing: 10) {
            HStack{
                
                Button(action: {
                    dismiss()
                }){
                    HStack {
                        Text("Cancelar")
                            .font(.headline)
                        
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
                .foregroundColor(.white)
                
                
                //botón de crear usuario
                Button(action: {
                    
                    //Subir imagen a firebase
                    if let thisImage = self.upload_image {
                        Task {
                            await storage.uploadImage(image: thisImage, name: "Fotos_perfil/" + patientId + "profile_picture") { url in
                                
                                imageURL = url
                                
                                //Checar que datos son validos
                                if(firstName != "" || lastName != "" || group != "" || communicationStyleSelector != "" || congnitiveLevelSelector != ""){
                                    isSaving = true
                                    uploadPatient.toggle()
                                    dismiss()
                                }
                                else{
                                    showAlert = true
                                }
                            }
                        }
                    } else {
                        //Checar que datos son validos
                        if(firstName != "" && lastName != "" && group != "" && communicationStyleSelector != "" && congnitiveLevelSelector != ""){
                            isSaving = true
                            uploadPatient.toggle()
                            dismiss()
                             
                        }
                        else{
                            showAlert = true
                        }
                    }
                }){
                    HStack {
                        Text("Guardar")
                            .font(.headline)
                        
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                    }
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
                .allowsHitTesting(!isSaving)
                .alert("Todos los campos deben ser llenados", isPresented: $showAlert){
                    Button("Ok") {}
                }
            message: {
                Text("Asegurate de haber llenado todos los campos requeridos")
            }
            }
        }
        .padding()
        .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $upload_image)
            
        }
        .onDisappear {
            if(uploadPatient) {
                let patient = Patient(id: patientId ,firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyleSelector, cognitiveLevel: congnitiveLevelSelector, image: imageURL?.absoluteString ?? "placeholder", notes: [String](), identificador: patientId)
                
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

