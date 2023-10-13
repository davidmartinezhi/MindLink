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
    struct AlertItem: Identifiable {
        var id = UUID()
        var title: Text
        var message: Text?
        var dismissButton: Alert.Button?
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
    
    @State private var alertItem: AlertItem?
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
            
            HStack {
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
                
                //Registrar
                Button(action: {
                    if(password != confirmpassword){
                        self.alertItem = AlertItem(title: Text("Confirme su contraseña"), message: Text("Por favor, verifique correctmente su contraseña."), dismissButton: .cancel(Text("OK")))
                    } else if (!email.isValidEmail()){
                        self.alertItem = AlertItem(title: Text("Correo Invalido"), message: Text("verifique que su correo sea correcto."), dismissButton: .cancel(Text("OK")))
                    } else if (!password.isWeakPassword()){
                        self.alertItem = AlertItem(title: Text("Contraseña invalida"), message: Text("verifique que su contraseña tenga minimo 8 caracteres, un caracter en mayuscula, un caracter especial y un número."), dismissButton: .cancel(Text("OK")))
                    } else {
                        Task {
                             _ = await authVM.createNewAuthAccount(email: email, password: password, currUserPassword: authPassword)
                        }
                        dismiss()
                    }
                }) {
                    HStack {
                        Text("Registrar")
                            .font(.headline)
                        
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                    }
                }
                .padding()
                .background(email.isEmpty || password.isEmpty || name.isEmpty ?  .gray : .blue )
                .cornerRadius(10)
                .foregroundColor(.white)
                
            }
            .alert(item: $alertItem ) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            // Añadir mensaje
        }
        .padding()
        .padding(.horizontal, 70)
        .alert("Escribe tu contraseña", isPresented: $showAuthAlert, actions: {
            TextField("Contraseña", text: $authPassword)
                .autocorrectionDisabled(true)
            
            Button("Okay", action: {
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
