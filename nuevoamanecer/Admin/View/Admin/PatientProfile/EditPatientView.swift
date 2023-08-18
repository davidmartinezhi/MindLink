//
//  EditPatientView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 26/05/23.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import Kingfisher

struct EditPatientView: View {
    @ObservedObject var patients: PatientsViewModel
    @State var patient: Patient
    @Environment(\.dismiss) var dismiss

    
    var cognitiveLevels = ["Alto", "Medio", "Bajo"]
    @State private var congnitiveLevelSelector = ""
    
    var communicationStyles = ["Verbal", "No-verbal", "Mixto"]
    @State private var communicationStyleSelector = ""
    
    @State var showAlert : Bool = false
    @State private var showAlertNoImage = false
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var birthDate : Date = Date.now
    @State private var group : String = ""
    @State private var upload_image: UIImage?
    @State private var deletedImage = false
    @State private var identificador : String = ""

    @State private var storage = FirebaseAlmacenamiento()
    
    @State private var shouldShowImagePicker = false
    
    @State private var imageURL = URL(string: "")
    @State private var uploadPatient: Bool = false
    
    
    func initializeData(patient: Patient) -> Void{
        firstName = patient.firstName
        lastName = patient.lastName
        birthDate = patient.birthDate
        group = patient.group
        //image = patient.image
        communicationStyleSelector = patient.communicationStyle
        congnitiveLevelSelector = patient.cognitiveLevel
        identificador = patient.id
    }
    
    func loadImageFromFirebase(name:String) {
        let storageRef = Storage.storage().reference(withPath: name)
        
        storageRef.downloadURL { (url, error) in
            if error != nil {
                print("Este usuario no tiene una imagen de perfil")
                return
            }
            self.imageURL = url!
        }
    }
    
    
    
    var body: some View {
        
        VStack{
            
            //Delete patient button
            DeletePatientView(patients:patients, patient:patient)

            
            //Imagen del niño
            VStack{
                
                VStack{
                    Menu {
                        Button(action: {
                            shouldShowImagePicker.toggle()
                            deletedImage = false
                            
                        }, label: {
                            Text("Seleccionar Imagen")
                        })
                        Button(action: {
                            if (patient.image == "placeholder" || deletedImage) {
                                showAlertNoImage.toggle()
                            } else {
                                deletedImage = true
                            }
                        }, label: {
                            Text("Eliminar Imagen")
                        })
                    } label: {
                        
                        //Imagen recien cargada
                        if let displayImage = self.upload_image {
                            Image(uiImage: displayImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(128)
                                .padding(.horizontal, 20)
                        } else {
                            
                            //No imagen
                            if(patient.image == "placeholder" || deletedImage) {
                                ZStack{
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
                            
                            //Imagen previamente subida
                            else{
                                
                                ZStack{
                                    KFImage(URL(string: patient.image))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(128)
                                        .padding(.horizontal, 20)
                                    /* # Creo que es mejor quitar el lapiz azul cuando ya hay una foto de perfil #
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 40))
                                        .offset(x: 40, y: 40)
                                        .foregroundColor(.blue)
                                     */
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    //Spacer()
                }
                .frame(maxHeight: 130)
                
            }
            .alert("Error", isPresented: $showAlertNoImage){
                Button("Ok") {}
            }
        message: {
            Text("Este perfil no cuenta con imagen")
        }
                
                
            
            
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
            
            HStack{
                //Cancel
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
                
                
                //Save
                Button(action: {
                    //Subir imagen a firebase
                    if let thisImage = self.upload_image {
                        Task {
                            await storage.uploadImage(image: thisImage, name: "Fotos_perfil/" + patient.identificador + "profile_picture") { url in
                                
                                self.imageURL = url
                                
                                //Checar que datos son validos
                                if(firstName != "" || lastName != "" || group != "" || communicationStyleSelector != "" || congnitiveLevelSelector != ""){
                                    
                                    uploadPatient.toggle()
                                    dismiss()
                                     
                                }
                                else{
                                    showAlert = true
                                }
                            }
                        }
                    }  else {
                        //Checar que datos son validos
                        if(firstName != "" && lastName != "" && group != "" && communicationStyleSelector != "" && congnitiveLevelSelector != ""){
                            uploadPatient.toggle()
                            dismiss()
                        } else {
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
                .alert("Datos faltantes", isPresented: $showAlert){
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
        .onAppear{
            initializeData(patient: patient)
            loadImageFromFirebase(name: "Fotos_perfil/" + patient.identificador + "profile_picture.jpg")
        }
        .onDisappear{
            if(uploadPatient){
                //Si se presiono el boton de eliminar imagen y despues guardar, se borra la imagen de la base de datos
                if(deletedImage) {
                    storage.deleteFile(name: "Fotos_perfil/" + patient.identificador + "profile_picture")
                    imageURL = URL(string: "placeholder")
                }
                let patient = Patient(id: patient.id ,firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyleSelector, cognitiveLevel: congnitiveLevelSelector, image: imageURL?.absoluteString ?? "placeholder", notes: [String](), identificador: patient.identificador)
                
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
        }
    }
}




struct EditPatientView_Previews: PreviewProvider {
    static var previews: some View {
        EditPatientView(patients: PatientsViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String](), identificador: ""))
    }
}

