//
//  RegisterView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    @State var email = ""
    @State var password = ""
    @State var authPassword = ""
    @State var name = ""
    @State var isAdmin = false
    @State var confirmpassword = ""
    
    @State private var mostrarAlerta = false
    @State private var mostrarAlerta1 = false
    @State private var showAuthAlert = true
    
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
                        authViewModel.createNewAccount(email: email, password: password, name: name, isAdmin: isAdmin)
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

            
            Button("Login", action: {
                if(authPassword != "hola"){
                    dismiss()
                }else{
                    print("hola")
                }
            })
            Button("Cancel", role: .cancel, action: { dismiss() })
        })
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authViewModel: AuthViewModel())
    }
}


