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
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var currentUser: UserWrapper
    
    @State var email = ""
    @State var password = ""
    @State var authPassword = ""
    @State var name = ""
    @State var isAdmin = false
    @State var confirmpassword = ""
    
    @State private var mostrarAlerta = false
    @State private var mostrarAlerta1 = false
    @State private var showAuthAlert = true
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @FocusState private var inFocus: Field?
    @FocusState private var inFocusConfirm: Field?
        
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
                    TextField("Confirmar Contraseña", text: $confirmpassword)
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
                    SecureField("Confirmar Contraseña", text: $confirmpassword)
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
                } else if (password.isWeakPassword()){
                    mostrarAlerta1 = true
                } else {
                    Task {
                        _ = await authVM.createNewAuthAccount(email: email, password: password, currUserPassword: authPassword)
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
                Text("Verifique su contraseña")
            }
            .alert("Contraseña inválida",isPresented: $mostrarAlerta1){
                Button("OK"){}
            } message: {
                Text("La contraseña debe de contener 8 caracteres, con mínimo un número, una mayúscula y un carácter especial.")
            }
            
            // Añadir mensaje
        }
        .padding()
        .padding(.horizontal, 70)
        .alert("Escribe tu contraseña", isPresented: $showAuthAlert, actions: {
            TextField("Contraseña", text: $authPassword)
                .autocorrectionDisabled(true)
            
            Button("Ok", action: {
                Task {
                    let result: AuthActionResult = await authVM.loginAuthUser(email: currentUser.email!, password: authPassword)
                    
                    if result.success {
                        // Exito
                    } else {
                        dismiss()
                    }
                }
            })
            Button("Cancel", role: .cancel, action: { dismiss() })
        })
    }
}
