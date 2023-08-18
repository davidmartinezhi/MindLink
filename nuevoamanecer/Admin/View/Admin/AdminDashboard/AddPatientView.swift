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
    @ObservedObject var patients: PatientsViewModel
    
    // Variables para los selectores de nivel cognitivo y estilo de comunicación
    var cognitiveLevels = ["Alto", "Medio", "Bajo"]
    @State private var congnitiveLevelSelector = ""
    
    var communicationStyles = ["Verbal", "No-verbal", "Mixto"]
    @State private var communicationStyleSelector = ""
    
    // Variables para los campos de texto del formulario
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate: Date = Date()
    @State private var group: String = ""
    @State private var upload_image: UIImage?
    
    // Variables para mostrar alertas de error
    @State private var showAlert = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var hasSelectedBirthday: Bool = false
    
    // Variables para la carga de imágenes en Firebase
    @State private var storage = FirebaseAlmacenamiento()
    @State private var shouldShowImagePicker = false
    @State private var imageURL = URL(string: "")
    @State private var uploadPatient: Bool = false
    @State var isSaving: Bool = false
    
    
    
    
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
    func loadImageFromFirebase(name: String) {
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
                            .onChange(of: birthDate, perform: { value in
                                                hasSelectedBirthday = true
                                            })
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
                            await storage.uploadImage(image: thisImage, name: lastName + firstName + "profile_picture") { url in
                                
                                imageURL = url
                                
                                //Validamos que no existan campos vaciós
                                if(firstName == "" || lastName == "" || group == "" || communicationStyleSelector == "" || congnitiveLevelSelector == ""){
                                    errorTitle = "Campos vacíos"
                                    errorMessage = "Todos los campos deben ser llenados"
                                    showAlert = true
                                }
                                //Validamos que selecciono una fecha de nacimiento
                                else if(!hasSelectedBirthday){
                                    errorTitle = "Campos vacíos"
                                    errorMessage = "Debes seleccionar una fecha de cumpleaños"
                                    showAlert = true
                                }
                                //Validamos que no existán caracteres especiales en nombre
                                else if(!isValidName(name: firstName) || !isValidName(name: lastName)){
                                    errorTitle = "Favor de volver a ingresar sus datos"
                                    errorMessage = "El nombre y apellido deben contener solamente letras y no tener espacios en blanco al inicio"
                                    firstName = ""
                                    lastName = ""
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
                                    isSaving = true
                                    uploadPatient.toggle()
                                    dismiss()
                                }
                            }
                        }
                    } else {
                        
                        //Validamos que no existan campos vaciós
                        if(firstName == "" || lastName == "" || group == "" || communicationStyleSelector == "" || congnitiveLevelSelector == ""){
                            errorTitle = "Campos vacíos"
                            errorMessage = "Todos los campos deben ser llenados"
                            showAlert = true
                        }
                        //Validamos que selecciono una fecha de nacimiento
                        else if(!hasSelectedBirthday){
                            errorTitle = "Campos vacíos"
                            errorMessage = "Debes seleccionar una fecha de cumpleaños"
                            showAlert = true
                        }
                        //Validamos que no existán caracteres especiales en nombre
                        else if(!isValidName(name: firstName) || !isValidName(name: lastName)){
                            errorTitle = "Favor de volver a ingresar sus datos"
                            errorMessage = "El nombre y apellido deben contener solamente letras y no tener espacios en blanco al inicio"
                            firstName = ""
                            lastName = ""
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
                            isSaving = true
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
                .allowsHitTesting(!isSaving)
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

