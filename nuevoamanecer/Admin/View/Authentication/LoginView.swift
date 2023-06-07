//
//  LoginView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var email = ""
    @State var password = ""

    var body: some View {
        GeometryReader { geometry in
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
                        authViewModel.loginUser(email: email, password: password)
                    }
                }) {
                    Text("Iniciar sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if let messageError = authViewModel.errorMessage {
                    Text(messageError)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
            }
            .frame(maxWidth: min(500, geometry.size.width), alignment: .center)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .navigationTitle("")
        }
        .navigationViewStyle(.stack)
        .accentColor(.black) // Cambia el color del título y los enlaces de navegación a negro para un aspecto más profesional
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel())
    }
}

