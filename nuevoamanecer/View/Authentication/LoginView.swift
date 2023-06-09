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
    @State private var contraseñaIncorrecta: Bool = false
    @State private var usuarioNoExiste: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Iniciar sesión")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                
                TextField("Correo electrónico", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .autocapitalization(.none) // para evitar errores de correo electrónico en mayúsculas
                
                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                Button(action: {
                    Task {
                        if(email != "" && password != "") {
                            authViewModel.loginUser(email: email, password: password)
                            
                            if(authViewModel.errorMessage != nil) {
                                showAlert.toggle()
                            }
                        } else {
                            authViewModel.errorMessage = "Favor de completar todos los campos"
                            showAlert.toggle()
                        }
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
                .alert("Error", isPresented: $showAlert){
                    Button("Ok") {}
                }
            message: {
                Text(authViewModel.errorMessage!)
            }
                
                /*
                if let messageError = authViewModel.errorMessage {
                    Text(messageError)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
                 */
            }
            .frame(maxWidth: min(500, geometry.size.width), alignment: .center)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .background(Color.white)
            .navigationTitle("")
        }
        .navigationViewStyle(.stack)
        .accentColor(.blue) // Cambia el color del título y los enlaces de navegación a azul para un aspecto más profesional
    }
}





struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel())
    }
}

