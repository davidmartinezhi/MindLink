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
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var birthDate : Date = Date.now
    @State private var group : String = ""
    @State private var upload_image: UIImage?

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
    }
    
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
            
            //Delete patient button
            DeletePatientView(patients:patients, patient:patient)

            
            //Imagen del niño
            VStack{
                
                VStack{
                    Button() {
                        shouldShowImagePicker.toggle()
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
                            if(patient.image == "placeholder") {
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
                                    
                                    Image(systemName: "pencil")
                                        .font(.system(size: 25))
                                        .offset(x: 35, y: 40)
                                        .foregroundColor(.blue)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                        }
                    }
                    //Spacer()
                }
                .frame(maxHeight: 130)
                
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
                    } else {
                        //Checar que datos son validos
                        if(firstName == "" || lastName == "" || group == "" || communicationStyleSelector == "" || congnitiveLevelSelector == "" || upload_image == nil){
                            
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
                
            }
        }
        .padding()
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $upload_image)
        }
        .onAppear{
            initializeData(patient: patient)
            loadImageFromFirebase(name: lastName + firstName + "profile_picture.jpg")
        }
        .onDisappear{
            if(uploadPatient){
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
        
        /*
        NavigationView {
            VStack {
                
                /*HStack{
                    
                    
                    Text("Editar Información")
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                }
                .padding()
                */
                
                
                
                //Imagen del niño
                VStack {
                    if let displayImage = self.upload_image {
                        Image(uiImage: displayImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(128)
                    } else {
                        WebImage(url: imageURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(128)
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 64)
                    .stroke(Color.black, lineWidth: 3))
                
                
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
                    
                    Section(header: Text("Foto de perfil")) {
                        Button() {
                            shouldShowImagePicker.toggle()
                        } label: {
                            Text("Seleccionar imagen")
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
                        
                        DeletePatientView(patients:patients, patient:patient)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 55, alignment: .center)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $upload_image)
            }
        }
        .onAppear {
            initializeData(patient: patient)
            loadImageFromFirebase(name: lastName + firstName + "profile_picture.jpg")
        }
         */
    }
}




struct EditPatientView_Previews: PreviewProvider {
    static var previews: some View {
        EditPatientView(patients: PatientsViewModel(), patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()))
    }
}
