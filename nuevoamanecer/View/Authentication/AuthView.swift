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
            GeometryReader { geometry in
                VStack(spacing: 50) {
                    Text("Inicia sesión para tener acceso a tus niños")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Administra a tus pacientes, guarda su información y accede al comunicador universal de cada uno de ellos.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    NavigationLink(destination: LoginView(authViewModel: authViewModel)) {
                        Text("Iniciar sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: RegisterView(authViewModel: authViewModel)) {
                        Text("Registrarse")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                     
                }
                .frame(maxWidth: min(500, geometry.size.width), alignment: .center)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding()
                .navigationTitle("")
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.black) // Cambia el color del título y los enlaces de navegación a negro para un aspecto más profesional
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(authViewModel: AuthViewModel())
    }
}

