//
//  RegisterView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct RegisterView: View {
    enum Field : Hashable {
        case plain
        case secure
    }
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    var user: User
    @State var email = ""
    @State var password = ""
    @State var authPassword = ""
    @State var name = ""
    @State var isAdmin = false
    @State var confirmpassword = ""
    @State var adminEmail: String
    
    @State private var mostrarAlerta = false
    @State private var mostrarAlerta1 = false
    @State private var showAuthAlert = true
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @FocusState private var inFocus: Field?
    @FocusState private var inFocusConfirm: Field?
    
    init(authViewModel: AuthViewModel, user: User) {
        self.authViewModel = authViewModel
        self.user = user
        _adminEmail = State(initialValue: user.email)
    }
    
    var body: some View {
        VStack {
            Text("Registrarse")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: 600)
            
            TextField("Nombre", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .textContentType(.username)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .cornerRadius(10)
                .padding(.bottom, 20)
                .frame(maxWidth: 600)
            
            TextField("Correo electrónico", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .frame(maxWidth: 600)
            
            ZStack (alignment: .trailing) {
                if showPassword {
                    TextField("Contraseña", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .textContentType(.newPassword)
                    .frame(maxWidth: 600)
                    .focused($inFocus, equals: .plain)
                } else {
                    SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .textContentType(.newPassword)
                    .frame(maxWidth: 600)
                    .focused($inFocus, equals: .secure)
                }
                Button() {
                    showPassword.toggle()
                    inFocus = showPassword ? .plain : .secure
                } label: {
                    Image(systemName: showPassword ? "eye" : "eye.slash")
                    .padding(.bottom)
                    .padding(.trailing)
                }
            }
            
            ZStack (alignment: .trailing) {
                if showConfirmPassword {
                    TextField("Confrimar Contraseña", text: $confirmpassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .textContentType(.newPassword)
                    .frame(maxWidth: 600)
                    .focused($inFocusConfirm, equals: .plain)
                } else {
                    SecureField("Confrimar Contraseña", text: $confirmpassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                        .autocorrectionDisabled(true)
                        .textContentType(.password)
                        .frame(maxWidth: 600)
                        .focused($inFocusConfirm, equals: .secure)
                }
                Button() {
                    showConfirmPassword.toggle()
                    inFocusConfirm = showConfirmPassword ? .plain : .secure
                } label: {
                    Image(systemName: showConfirmPassword ? "eye" : "eye.slash")
                    .padding(.bottom)
                    .padding(.trailing)
                }
            }
            
            
            Toggle(isOn: $isAdmin) {
                Text("¿Es administrador?")
            }
            .padding(.bottom, 20)

            Button(action: {
                if(password != confirmpassword){
                    mostrarAlerta = true
                } else if (authViewModel.isWeak(password)){
                    mostrarAlerta1 = true
                } else {
                    Task {
                        authViewModel.createNewAccount(email: email, password: password, name: name, isAdmin: isAdmin, adminEmail: adminEmail, adminPassword: authPassword)
                    }
                    dismiss()
                }
            }) {
                Text("Registrarse")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(email.isEmpty || password.isEmpty || name.isEmpty ?  .gray : .blue )
                    .cornerRadius(10)
            }
            .frame(maxWidth: 600)
            .disabled(email.isEmpty || password.isEmpty || name.isEmpty)
            .alert("Error", isPresented: $mostrarAlerta){
                Button("OK"){}
            }
            message: {
                Text("Verifique sucontraseña")
            }
            .alert("Contraseña Invalida",isPresented: $mostrarAlerta1){
                Button("OK"){}
            } message: {
                Text("La contraseña debe de contere 8 caracteres, con minimo un numero , una mayuscula y un caracter especial")
            }
            
            if let messageError = authViewModel.errorMessage {
                Text(messageError)
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
        }
        .padding()
        .padding(.horizontal, 70)
        .alert("Escribe tu contraseña", isPresented: $showAuthAlert, actions: {
            TextField("Contraseña", text: $authPassword)
                .autocorrectionDisabled(true)
            
            Button("Okay", action: {
                Task {
                    await self.authViewModel.autenticar(email: adminEmail, password: authPassword)
                    print(self.authViewModel.validar)
                    
                    if(self.authViewModel.validar != true){
                        dismiss()
                    }else{
                        self.authViewModel.validar.toggle()
                    }
                }
            })
            Button("Cancel", role: .cancel, action: { dismiss() })
        })
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authViewModel: AuthViewModel() ,user: User(id: "", name: "", email: "", isAdmin: false, image: ""))
    }
}


