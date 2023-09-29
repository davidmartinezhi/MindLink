//EditPatientView.swift
// nuevoamanecer
//
// Created by Gerardo Martínez on 26/05/23.

// Importación de bibliotecas y módulos necesarios
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import Kingfisher
import Foundation

// Definición de la vista EditPatientView
struct EditPatientView: View {
    // Objeto observado que contiene el modelo de vista de pacientes
    @ObservedObject var patients: PatientsViewModel
    // Estado que contiene la información del paciente que se está editando
    @Binding var patient: Patient
    // Variable de entorno para cerrar la vista
    @Environment(\.dismiss) var dismiss

    // Lista de niveles cognitivos
    var cognitiveLevels = ["Alto", "Medio", "Bajo"]
    // Selector de nivel cognitivo
    @State private var congnitiveLevelSelector = ""

    // Lista de estilos de comunicación
    var communicationStyles = ["Verbal", "No-verbal", "Mixto"]
    // Selector de estilo de comunicación
    @State private var communicationStyleSelector = ""

    // Variables de estado para controlar la interfaz de usuario y la lógica de la vista
    @State var showAlert : Bool = false
    @State private var showAlertNoImage = false
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var birthDate : Date = Date.now
    @State private var group : String = ""
    @State private var upload_image: UIImage?
    @State private var deletedImage = false
    @State private var identificador : String = ""

    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var storage = FirebaseAlmacenamiento()
    @State private var shouldShowImagePicker = false
    @State private var imageURL = URL(string: "")
    @State private var uploadPatient: Bool = false
    
    
    // Función para inicializar los datos del paciente en la vista
    func initializeData(patient: Patient) -> Void{
        firstName = patient.firstName
        lastName = patient.lastName
        birthDate = patient.birthDate
        group = patient.group
        communicationStyleSelector = patient.communicationStyle
        congnitiveLevelSelector = patient.cognitiveLevel
        identificador = patient.id
    }

    
    // Función para cargar la imagen del paciente desde Firebase
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
        // Contenedor vertical que agrupa los elementos de la vista
          VStack{
              // Vista para eliminar al paciente
              DeletePatientView(patients:patients, patient: patient)
            //Form
            VStack{
                Form {
                    Section(header: Text("Foto del paciente")) {
                        HStack{
                            Spacer()
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

                                    ZStack{
                                        Image(uiImage: displayImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 128, height: 128)
                                            .cornerRadius(128)
                                            .padding(.horizontal, 20)
                                        
                                        Image(systemName: "photo.on.rectangle.fill")
                                            .font(.system(size: 25))
                                            .offset(x: 53, y: 50)
                                            //.foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 20)
                                } else {
                                    
                                    //No imagen
                                    if(patient.image == "placeholder" || deletedImage) {
                                        ZStack{
                                            Text(patient.firstName.prefix(1) + patient.lastName.prefix(1))
                                                .textCase(.uppercase)
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .frame(width: 128, height: 128)
                                                .background(Color(.systemGray3))
                                                .foregroundColor(.white)
                                                .clipShape(Circle())
                                                .padding(.trailing)
                                            
                                            Image(systemName: "photo.on.rectangle.fill")
                                                .font(.system(size: 25))
                                                .offset(x: 53, y: 50)
                                                //.foregroundColor(.white)
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

                                            Image(systemName: "photo.on.rectangle.fill")
                                                .font(.system(size: 25))
                                                .offset(x: 53, y: 50)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .alert("Error", isPresented: $showAlertNoImage){
                            Button("Ok") {}
                        }
                        message: {
                            Text("Este perfil no cuenta con imagen")
                        }
                    }
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
                                
                                //Validamos que no existan campos vaciós
                                if(firstName == "" || lastName == "" || group == "" || communicationStyleSelector == "" || congnitiveLevelSelector == ""){
                                    errorTitle = "Campos vacíos"
                                    errorMessage = "Todos los campos deben ser llenados"
                                    showAlert = true
                                }
                                //Validamos que no existán caracteres especiales en nombre
                                else if(!isValidName(name: firstName) || !isValidName(name: lastName)){
                                    errorTitle = "Favor de volver a ingresar sus datos"
                                    errorMessage = "Nombre y apellido del paciente deben contener solamente letras y no tener espacios en blanco al inicio"
                                    firstName = ""
                                    lastName = ""
                                    showAlert = true
                                }
                                //Validamos que el grupo tenga un nombre valido. solo letras y numeros
                                else if(!isValidOnlyCharAndNumbers(input: group)){
                                    errorTitle = "Nombre de grupo invalido"
                                    errorMessage = "Nombre del grupo debe contener solamente letras y no tener espacios en blanco al inicio"
                                    group = ""
                                    showAlert = true
                                }
                                //Validamos que la fecha de nacimiento no sea en el futuro o en el mes previo
                                //La razón del mes previo es para promover que escriban la fecha de nacimiento correcta
                                else if(!isValidBirthDate(birthDate: birthDate)){
                                    errorTitle = "Fecha de nacimiento invalida"
                                    errorMessage = "Ingresa una fecha de nacimiento previa a un mes"
                                    showAlert = true
                                }
                                //Actualización de datos en la base de datos
                                else {
                                    uploadPatient.toggle()
                                    dismiss()
                                }
                            }
                        }
                    }  else {
                        
                        //Validamos que no existan campos vaciós
                        if(firstName == "" || lastName == "" || group == "" || communicationStyleSelector == "" || congnitiveLevelSelector == ""){
                            errorTitle = "Campos vacíos"
                            errorMessage = "Todos los campos deben ser llenados."
                            showAlert = true
                        }
                        //Validamos que no existán caracteres especiales en nombre
                        else if(!isValidName(name: firstName) || !isValidName(name: lastName)){
                            errorTitle = "Favor de volver a ingresar sus datos"
                            errorMessage = "Nombre y apellido del paciente deben contener solamente letras y no tener espacios en blanco al inicio"
                            firstName = ""
                            lastName = ""
                            showAlert = true
                        }
                        //Validamos que el grupo tenga un nombre valido. solo letras y numeros
                        else if(!isValidOnlyCharAndNumbers(input: group)){
                            errorTitle = "Nombre de grupo invalido"
                            errorMessage = "Nombre del grupo debe contener solamente letras y no tener espacios en blanco al inicio"
                            group = ""
                            showAlert = true
                        }
                        //Validamos que la fecha de nacimiento no sea en el futuro o en el mes previo
                        //La razón del mes previo es para promover que escriban la fecha de nacimiento correcta
                        else if(!isValidBirthDate(birthDate: birthDate)){
                            errorTitle = "Fecha de nacimiento invalida"
                            errorMessage = "Ingresa una fecha de nacimiento previa a un mes"
                            showAlert = true
                        }
                        //Actualización de datos en la base de datos
                        else {
                            uploadPatient.toggle()
                            dismiss()
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
                
                .alert(errorTitle, isPresented: $showAlert){
                    Button("Ok") {}
                }
            message: {
                Text(errorMessage)
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
                let backupPatient = patient
                //Si se presiono el boton de eliminar imagen y despues guardar, se borra la imagen de la base de datos
                if(deletedImage) {
                    storage.deleteFile(name: "Fotos_perfil/" + patient.identificador + "profile_picture")
                    imageURL = URL(string: "placeholder")
                }
                let patient = Patient(id: patient.id ,firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyleSelector, cognitiveLevel: congnitiveLevelSelector, image: imageURL?.absoluteString ?? "placeholder", notes: [String](), identificador: patient.identificador)
                self.patient = patient
                //call method for update
                patients.updateData(patient: patient){ error in
                    if error != "OK" {
                        print(error)
                        self.patient = backupPatient
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

