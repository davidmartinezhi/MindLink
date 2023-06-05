//
//  AuthView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                Text("Bienvenido a nuestra aplicación")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Una breve descripción de lo que hace tu aplicación.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: LoginView(authViewModel: authViewModel)) {
                    Text("Iniciar sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: RegisterView(authViewModel: authViewModel)) {
                    Text("Registrarse")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                 
            }
            .padding()
            .navigationTitle("Inicio")
            
        }
        .navigationViewStyle(.stack)
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(authViewModel: AuthViewModel())
    }
}

