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
    @State var patient: Patient
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
    }
    
    
    // Función para validar si un nombre es válido utilizando una expresión regular
    func isValidName(name: String) -> Bool {
        // Elimina los espacios en blanco al final del nombre
        let trimmedName = name.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        // Expresión regular para validar el nombre
        let pattern = "^[A-Za-zÀ-ÖØ-öø-ÿ]+(?: [A-Za-zÀ-ÖØ-öø-ÿ]+)*$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: trimmedName.utf16.count)
        return regex?.firstMatch(in: trimmedName, options: [], range: range) != nil
    }
    
    // Función para validar si una fecha de cumpleaños es válida
    func isValidBirthDate(birthDate: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        
        // Verifica si la fecha de nacimiento está en el futuro
        if birthDate.compare(currentDate) == .orderedDescending {
            return false
        }
        
        // Verifica si la fecha de nacimiento está en el mes previo
        if birthDate.compare(oneMonthAgo) == .orderedDescending {
            return false
        }
        
        return true
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
              DeletePatientView(patients:patients, patient:patient)

              // Contenedor para la imagen del paciente
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
                            await storage.uploadImage(image: thisImage, name: lastName + firstName + "profile_picture") { url in
                                
                                imageURL = url
                                
                                //Validamos que no existan campos vaciós
                                if(firstName == "" || lastName == "" || group == "" || communicationStyleSelector == "" || congnitiveLevelSelector == ""){
                                    errorTitle = "Campos vacíos"
                                    errorMessage = "Todos los campos deben ser llenados."
                                    showAlert = true
                                }
                                //Validamos que no existán caracteres especiales en nombre
                                else if(!isValidName(name: firstName) || !isValidName(name: lastName)){
                                    errorTitle = "Nombre y/ apellido no valido"
                                    errorMessage = "El nombre y apellido deben de solamente contener letras."
                                    showAlert = true
                                }
                                //Validamos que la fecha de nacimiento no sea en el futuro o en el mes previo
                                //La razón del mes previo es para promover que escriban la fecha de nacimiento correcta
                                else if(!isValidBirthDate(birthDate: birthDate)){
                                    errorTitle = "Fecha de nacimiento incorrecta"
                                    errorMessage = "Ingresa una fecha de nacimiento parevia a un mes"
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
                            errorTitle = "Nombre y/ apellido no valido"
                            errorMessage = "El nombre y apellido deben de solamente contener letras."
                            showAlert = true
                        }
                        //Validamos que la fecha de nacimiento no sea en el futuro o en el mes previo
                        //La razón del mes previo es para promover que escriban la fecha de nacimiento correcta
                        else if(!isValidBirthDate(birthDate: birthDate)){
                            errorTitle = "Fecha de nacimiento incorrecta"
                            errorMessage = "Ingresa una fecha de nacimiento parevia a un mes"
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
            loadImageFromFirebase(name: lastName + firstName + "profile_picture.jpg")
        }
        .onDisappear{
            if(uploadPatient){
                //Si se presiono el boton de eliminar imagen y despues guardar, se borra la imagen de la base de datos
                if(deletedImage) {
                    storage.deleteFile(name: lastName + firstName + "profile_picture")
                    imageURL = URL(string: "placeholder")
                }
                let patient = Patient(id: patient.id ,firstName: firstName, lastName: lastName, birthDate: birthDate, group: group, communicationStyle: communicationStyleSelector, cognitiveLevel: congnitiveLevelSelector, image: imageURL?.absoluteString ?? "placeholder", notes: [String]())
                
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
        EditPatientView(patients: PatientsViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()))
    }
}

