//
//  AdminMenuView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 06/06/23.
//

import SwiftUI
import Kingfisher

struct AdminMenuView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    var user: User
    @State private var name: String
    @State private var email: String
    @State private var password = ""
    @State private var confirmpassword = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var showLogoutAlert = false
    
    @State private var upload_image: UIImage?
    @State private var shouldShowImagePicker: Bool = false
    @State private var uploadData: Bool = false
    @State private var imageURL = URL(string: "")
    @State private var storage = FirebaseAlmacenamiento()

    init(authViewModel: AuthViewModel, user: User) {
        self.authViewModel = authViewModel
        self.user = user
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
    }
    
    var body: some View {
        VStack {
            VStack {
                
                //Imagen del usuario
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
                                //No imagen
                                if(user.image == "placeholder") {
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
                                        KFImage(URL(string: user.image))
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
                .padding(.top, 30)
                .frame(maxHeight: 150)
                
                /*
                Image(systemName: "person.circle")
                    .font(.system(size: 80))
                    //.foregroundColor(Color(.label))
                    .foregroundColor(.gray)
                 */
                
                Text(name)
                    .font(.title)
                    .bold()
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            .frame(maxHeight: 150)
            //.padding(.top, 50)
            
            VStack{
                Form {
                    Section(header: Text("Información")) {
                        TextField("Nombre", text: $name)
                            .textContentType(.username)
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                        SecureField("Nueva contraseña", text: $password)
                            .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                        .autocorrectionDisabled(true)
                        .textContentType(.newPassword)
                        if (password != ""){
                            SecureField("confirmar contraseña", text: $confirmpassword)
                                .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                            .autocorrectionDisabled(true)
                            .textContentType(.newPassword)
                        }
                    }
                }
            }
            .frame(maxHeight: 300)
            
            //Spacer()
            VStack(alignment: .leading, spacing: 10) {
                
                HStack{
                    //Cancelar
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
                    
                    
                    //Guardar
                    Button(action: {
                        
                        if let thisImage = self.upload_image {
                            Task {
                                await storage.uploadImage(image: thisImage, name: user.name + "admin_profile_picture") { url in
                                    
                                    imageURL = url
                                    
                                    //Checar que datos son validos
                                    if (name.isEmpty || email.isEmpty) {
                                        self.alertTitle = "Faltan campos"
                                        self.alertMessage = "Por favor, rellena todos los campos antes de guardar la nota."
                                        self.showingAlert = true
                                    } else if (password != confirmpassword) {
                                        self.alertTitle = "Confirme su contraseña"
                                        self.alertMessage = "Por favor, confirme correctamente su contraseña."
                                        self.showingAlert = true
                                    } else if (authViewModel.isWeak(password) && !password.isEmpty){
                                        self.alertTitle = "Contraseña Invalida"
                                        self.alertMessage = "La contraseña debe de contere 8 caracteres, con minimo un numero , una mayuscula y un caracter especial."
                                        self.showingAlert = true
                                    } else{
                                        uploadData.toggle()
                                        dismiss()
                                    }
                                }
                            }
                        } else {
                            //Checar que datos son validos
                            if (name.isEmpty || email.isEmpty) {
                                self.alertTitle = "Faltan campos"
                                self.alertMessage = "Por favor, rellena todos los campos antes de guardar la nota."
                                self.showingAlert = true
                                
                            } else if (password != confirmpassword) {
                                self.alertTitle = "Confirme su contraseña"
                                self.alertMessage = "Por favor, confirme correctamente su contraseña."
                                self.showingAlert = true
                            } else if (authViewModel.isWeak(password) && !password.isEmpty){
                                self.alertTitle = "Contraseña Invalida"
                                self.alertMessage = "La contraseña debe de contere 8 caracteres, con minimo un numero , una mayuscula y un caracter especial."
                                self.showingAlert = true
                            } else{
                                uploadData.toggle()
                                dismiss()
                            }
                        }
                    
                    }) {
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
            
            Spacer()
        }
        .padding()
        .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $upload_image)
        }
        .alert(alertTitle, isPresented: $showingAlert){
            Button("OK"){}
        } message: {
            Text(alertMessage)
        }
        .onDisappear{
            if(uploadData) {
                self.name = name
                self.email = email
                
                authViewModel.updateUser(name: name, isAdmin: user.isAdmin, image: imageURL?.absoluteString ?? "placeholder", email: email)
                authViewModel.updateAuthEmail(email: email)
                if(password != ""){
                    authViewModel.updateAuthPassword(password: password)
                }
            }
        }
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView(authViewModel: AuthViewModel() ,user: User(id: "", name: "", email: "", isAdmin: false, image: ""))
    }
}
