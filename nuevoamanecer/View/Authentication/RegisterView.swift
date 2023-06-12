//
//  RegisterView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var isAdmin = false
    @State var confirmpassword = ""
    @State var name = ""
    @State var isAdmin = false
    @State private var mostrarAlerta = false
    @State private var mostrarAlerta1 = false
    
    //funcion que verifique que la contraseña ingresada contenga los caracteres necesarios para tener una contraseña fuerte
    func isWeak (_ password: String)-> Bool{
        let passwordLenght = password.count
        var containsSynbol = false
        var containsNumber = false
        var containsUpercase = false
        for character in password {
            if ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character)){
                containsUpercase = true
            }
            if ("1234567890".contains(character)){
                containsNumber = true
            }
            if ("!?#$%&/()=;:_-.,°".contains(character)){
                containsSynbol = true
            }
        }
        if (passwordLenght > 8 && containsSynbol  && containsUpercase && containsNumber){
            return false
        } else {
            return true
        }
    }

    var body: some View {
        VStack {
            Text("Registrarse")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Correo electrónico", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            SecureField("Contraseña", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .textContentType(.newPassword)
            
            SecureField("Confrimar Contraseña", text: $confirmpassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .textContentType(.password)
            
            TextField("Nombre", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            Toggle(isOn: $isAdmin) {
                Text("¿Es administrador?")
            }
            .padding(.bottom, 20)

            Button(action: {
                if(password != confirmpassword){
                    mostrarAlerta = true
                } else if (isWeak(password)){
                    mostrarAlerta1 = true
                } else {
                    Task {
                        authViewModel.createNewAccount(email: email, password: password, name: name, isAdmin: isAdmin)
                    }
                }
            }) {
                Text("Registrarse")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .background(email.isEmpty || password.isEmpty || name.isEmpty ?  .gray : .green )
                    .cornerRadius(10)
            }
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
        .navigationTitle("Registrarse")
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authViewModel: AuthViewModel())
    }
}

