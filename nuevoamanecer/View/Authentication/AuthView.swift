//
//  AuthView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    
    @State var email = ""
    @State var password = ""
    @State private var contraseñaIncorrecta: Bool = false
    @State private var usuarioNoExiste: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        //Color.blue.opacity(0.9)
                        Color.blue
                            .ignoresSafeArea()
                        VStack {
                            Image("logo_white")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                                .padding()
                            
                            Text("“MindLink” – Creando conexiones mentales para facilitar la comunicación entre terapeutas y niños.")
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 80)
                                .padding(.bottom, 40)
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }.padding(.top, geometry.size.height * 0.1)
                        
                    }
                    .frame(height: geometry.size.height / 2)
                    
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        VStack(spacing: 20) {
                            Text("Inicia sesión para tener acceso a tus niños")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .padding(.bottom)
                            
                            NavigationLink(destination: LoginView(authViewModel: authViewModel)) {
                                Text("Iniciar sesión")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 80)
                        }
                        .padding(.bottom, geometry.size.height * 0.1)
                    }
                    .frame(height: geometry.size.height / 2)
                }
            }
            .accentColor(.white) // Cambia el color del título y los enlaces de navegación a blanco para un aspecto más profesional
        }
        .navigationViewStyle(.stack)
    }
}



struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(authViewModel: AuthViewModel())
    }
}

