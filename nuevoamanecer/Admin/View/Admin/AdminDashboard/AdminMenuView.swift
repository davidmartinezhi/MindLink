//
//  AdminMenuView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 06/06/23.
//

import SwiftUI
import Kingfisher
import FirebaseStorage

struct AdminMenuView: View {
    struct AlertItem: Identifiable {
        var id = UUID()
        var title: Text
        var message: Text?
        var dismissButton: Alert.Button?
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    var userVM: UserViewModel = UserViewModel()
    var user: User
    
    @State private var name: String
    @State private var email: String
    @State private var oldEmail: String
    @State private var password = ""
    @State var authPassword = ""
    @State private var confirmpassword = ""
    
    @State private var showAuthAlert = false
    @State private var alertItem: AlertItem?
    
    @State private var showLogoutAlert = false
    
    @State private var uploaded_image: UIImage?
    @State private var shouldShowImagePicker: Bool = false
    @State private var uploadData: Bool = false
    @State private var imageURL = URL(string: "")
    @State private var storage = FirebaseAlmacenamiento()

    @State private var deletedImage = false
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var emailConfirm: String = ""
    @State private var emailValidation: String = ""
    @FocusState private var inFocus: Field?
    @FocusState private var inFocusConfirm: Field?
    
    enum Field : Hashable {
        case plain
        case secure
    }

    init(user: User) {
        self.user = user
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
        _oldEmail = State(initialValue: user.email)
    }
    
    var body: some View {
        VStack {
            VStack {
                Form {
                //Imagen del usuario
                Section(header: Text("Usuario")) {
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
                                if (user.image == "placeholder" || deletedImage) {
                                    self.alertItem = AlertItem(title: Text("Error"), message: Text("Este perfil no cuenta con imagen."), dismissButton: .cancel(Text("OK")))
                                } else {
                                    deletedImage = true
                                }
                            }, label: {
                                Text("Eliminar Imagen")
                            })
                        } label: {
                            
                            //Imagen recien cargada
                            if let displayImage = self.uploaded_image {
                                
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
                                if(user.image == nil || deletedImage) {
                                    
                                    ZStack{
                                        Text(user.name.prefix(1) + user.name.prefix(1))
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
                                        KFImage(URL(string: user.image!))
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
                    .alert(item: $alertItem ) { alertItem in
                        Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                    }
                    VStack{
                        HStack(alignment: .center){
                            Spacer()
                            Text(name)
                                .font(.title)
                                .bold()
                            Spacer()
                            
                        }
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                    
                    Section(header: Text("Información")) {
                        TextField("Nombre", text: $name)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        if (email == oldEmail) {
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                        } else {
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                            TextField("Confirmar Email", text: $emailValidation)
                                .textContentType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                        }

                        ZStack (alignment: .trailing) {
                            if showPassword {
                                TextField("Nueva contraseña", text: $password)
                                  .textInputAutocapitalization(.never)
                                  .keyboardType(.asciiCapable)
                                  .autocorrectionDisabled(true)
                                  .textContentType(.newPassword)
                                  .focused($inFocus, equals: .plain)
                            } else {
                                SecureField("Nueva contraseña", text: $password)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.asciiCapable)
                                    .autocorrectionDisabled(true)
                                    .textContentType(.newPassword)
                                    .focused($inFocus, equals: .secure)
                            }
                            Button() {
                                showPassword.toggle()
                                inFocus = showPassword ? .plain : .secure
                            } label: {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                            }
                        }
                        //
                        if (password != ""){
                            ZStack (alignment: .trailing) {
                                if showConfirmPassword {
                                    TextField("Confirmar contraseña", text: $confirmpassword)
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.asciiCapable)
                                        .autocorrectionDisabled(true)
                                        .textContentType(.password)
                                        .focused($inFocusConfirm, equals: .plain)
                                } else {
                                    SecureField("Confirmar contraseña", text: $confirmpassword)
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.asciiCapable)
                                        .autocorrectionDisabled(true)
                                        .textContentType(.password)
                                        .focused($inFocusConfirm, equals: .secure)
                                }
                                Button() {
                                    showConfirmPassword.toggle()
                                    inFocusConfirm = showConfirmPassword ? .plain : .secure
                                } label: {
                                    Image(systemName: showConfirmPassword ? "eye" : "eye.slash")
                                        //.padding(.bottom)
                                        //.padding(.trailing)
                                }
                            }
                        }
                        //
                    }
                }

            }
            .frame(minHeight: 150)
            .padding()
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
                        
                        if self.uploaded_image != nil {
                            Task {
                                await storage.uploadImage(image: self.uploaded_image!, name: "Fotos_perfil/" + self.user.id! + "admin_profile_picture") { url in
                                    
                                    imageURL = url
                                    
                                    //Checar que datos son validos
                                    if (name.isEmpty || email.isEmpty) {
                                        self.alertItem = AlertItem(title: Text("Faltan campos"), message: Text("Por favor, rellena todos los campos antes de guardar la información."), dismissButton: .cancel(Text("OK")))
                                    } else if (!email.isValidEmail()){
                                        self.alertItem = AlertItem(title: Text("Correo inválido"), message: Text("Verifique que su correo sea correcto."), dismissButton: .cancel(Text("OK")))
                                    } else if (password != confirmpassword) {
                                        self.alertItem = AlertItem(title: Text("Confirme su contraseña"), message: Text("Por favor, verifique correctmente su contraseña."), dismissButton: .cancel(Text("OK")))
                                    } else if (!PasswordValidator(password).isValidPassword() && !password.isEmpty){
                                        self.alertItem = AlertItem(title: Text("Contraseña inválida"), message: Text("La contraseña debe de contener 8 caracteres, con mínimo un numero, una mayúscula y un carácter especial."), dismissButton: .cancel(Text("OK")))
                                    } else if (email == emailValidation || emailValidation.isEmpty) {
                                        showAuthAlert = true
                                    } else {
                                        self.alertItem = AlertItem(title: Text("Correo electrónico no coincide"), message: Text("Los dos correos electrónicos ingresados no coinciden."), dismissButton: .cancel(Text("OK")))
                                    }
                                }
                            }
                        } else {
                            //Checar que datos son validos
                            if (name.isEmpty || email.isEmpty) {
                                self.alertItem = AlertItem(title: Text("Faltan campos"), message: Text("Por favor, rellena todos los campos antes de guardar la información."), dismissButton: .cancel(Text("OK")))
                            } else if (!email.isValidEmail()){
                                self.alertItem = AlertItem(title: Text("Correo inválido"), message: Text("Verifique que su correo sea correcto."), dismissButton: .cancel(Text("OK")))
                            } else if (password != confirmpassword) {
                                self.alertItem = AlertItem(title: Text("Confirme su contraseña"), message: Text("Por favor, verifique correctmente su contraseña"), dismissButton: .cancel(Text("OK")))
                            } else if (!PasswordValidator(password).isValidPassword() && !password.isEmpty){
                                self.alertItem = AlertItem(title: Text("Contraseña inválida"), message: Text("La contraseña debe de contener 8 caracteres, con mínimo un numero, una mayúscula y un carácter especial."), dismissButton: .cancel(Text("OK")))
                            } else if (email == emailValidation || emailValidation.isEmpty) {
                                showAuthAlert = true
                            } else {
                                self.alertItem = AlertItem(title: Text("Correo electrónico no coincide"), message: Text("Los dos correos electrónicos ingresados no coinciden."), dismissButton: .cancel(Text("OK")))
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
            ImagePicker(image: $uploaded_image)
        }
        .alert(item: $alertItem ) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .alert("Escribe tu contraseña", isPresented: $showAuthAlert, actions: {
            TextField("Contraseña", text: $authPassword)
                .autocorrectionDisabled(true)
            
            Button("Okay", action: {
                Task {
                    let result: AuthActionResult = await authVM.loginAuthUser(email: user.email, password: authPassword)
                    
                    if result.success {
                        uploadData.toggle()
                        dismiss()
                    } else {
                        self.alertItem = AlertItem(title: Text("Contraseña inválida"), message: Text("La contraseña es incorrecta."), dismissButton: .cancel(Text("OK")))
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {  })
            })
        .onDisappear{
            if (uploadData) {
                self.name = name
                self.email = email
                
                let _user: User = User(name: name, email: email, isAdmin: user.isAdmin, image: imageURL?.absoluteString)
                userVM.editUser(userId: user.id!, newUserValue: _user) { error in
                    if error != nil {
                        // Error
                    } else {
                        Task {
                            await authVM.updateCurrentAuthUser(value: email, userProperty: .email, currUserPassword: authPassword)
                        }
                    }
                }
                
                if !password.isEmpty {
                    Task {
                        let result: AuthActionResult = await authVM.updateCurrentAuthUser(value: password, userProperty: .password, currUserPassword: authPassword)
                        
                        if result.success {
                            // Exito
                        } else {
                            // Error
                        }
                    }
                }
            }
        }
    }
}
