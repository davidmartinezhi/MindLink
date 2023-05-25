//
//  LoginView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//
/*
import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack {
            Text("Iniciar sesión")
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
            
            Button(action: {
                Task {
                    await authViewModel.signIn(email: email, password: password)
                }
            }) {
                Text("Iniciar sesión")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            if let messageError = authViewModel.errorMessage {
                Text(messageError)
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
        }
        .padding()
        .navigationTitle("Iniciar sesión")
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel())
    }
}
*/
