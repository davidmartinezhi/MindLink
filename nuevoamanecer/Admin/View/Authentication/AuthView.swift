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
                VStack {
                    ZStack {
                        //Color.blue.opacity(0.9)
                        Color.blue
                            .ignoresSafeArea()
                        VStack {
                            Image("logo_white")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:300)
                                .padding([.leading, .trailing, .top])
                            
                            Text("Creando conexiones para facilitar la comunicación entre terapeutas y niños.")
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 80)
                                .padding(.bottom, 50)
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }.padding(.top, geometry.size.height * 0.1)
                        
                    }
                    .frame(height: geometry.size.height / 2)
                    
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        VStack(spacing: 20) {
                            Text("Accede a tu cuenta para ver a tus niños")
                                .font(.title)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .padding(.bottom)
                            
                            NavigationLink(destination: LoginView(authViewModel: authViewModel)) {
                                Text("Empezar")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: 600)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 80)
                            /*
                            NavigationLink(destination: RegisterView(authViewModel: authViewModel)) {
                                Text("Registrarse")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 80)
                             */
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

