//
//  RegisterView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//
/*
import SwiftUI

struct RegisterView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var isAdmin = false

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
                Task {
                    await authViewModel.register(email: email, password: password, name: name, isAdmin: isAdmin)
                    
                }
            }) {
                Text("Registrarse")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
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
*/
