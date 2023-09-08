//
//  LoginView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct LoginView: View {
    enum Field : Hashable {
        case plain
        case secure
    }
    
    @ObservedObject var authViewModel: AuthViewModel
    @State var email = ""
    @State var password = ""
    @State private var contraseñaIncorrecta: Bool = false
    @State private var usuarioNoExiste: Bool = false
    @State private var showAlert: Bool = false
    @State private var showPassword: Bool = false
    @FocusState private var inFocus: Field?

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
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none) // para evitar errores de correo electrónico en mayúsculas

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
                Button(action: {
                    Task {
                        authViewModel.loginUser(email: email, password: password)
                        
                        if(authViewModel.errorLogin != false) {
                            showAlert.toggle()
                        }
                    }
                }) {
                    Text("Iniciar sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(email.isEmpty || password.isEmpty ? .gray : .blue)
                        .cornerRadius(10)
                }
                .disabled(email.isEmpty || password.isEmpty)
                .padding(.horizontal)
                .alert("Verifique su correo y contraseña", isPresented: $showAlert){
                    Button(action: {authViewModel.errorLogin.toggle()}) {Text("Ok") }
                }
                message: {
                    Text("Puede que su correo o contraseña sean erroneos")
                }
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

