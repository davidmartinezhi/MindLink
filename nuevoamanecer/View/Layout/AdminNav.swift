//
//  AdminNav.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 05/06/23.
//

import SwiftUI
import Kingfisher

struct AdminNav: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    @Binding var showAdminView: Bool
    @Binding var showRegisterView: Bool
    
    @State private var showLogoutAlert = false
    
    var user: User


    var body: some View {
        ZStack {
            HStack {
                Image("logo_name")
                    .resizable()
                    //.renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 55)
                    .padding()
                Spacer()
                ZStack{
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                    Menu ("...."){
                        // boton para ir a la vista de perfil
                        Button(action: { showAdminView = true }) {
                            HStack {
                                Text("Mi perfil")
                                    .font(.system(size: 16))
                            }
                        }
                        
                        // solo usuarios administradores pueden crear otro usuario
                        if (user.isAdmin == true) {
                            // boton para ir a la vista de registro
                            Button(action: { showRegisterView = true }) {
                                HStack {
                                    Text("Registrar Usuario")
                                        .font(.system(size: 16))
                                }
                            }
                        }
                        // boton para cerrar sesion
                        Button(action: {
                            self.showLogoutAlert.toggle()
                        }) {
                            HStack {
                                Text("Cerrar sesión")
                                    .font(.system(size: 16))
                                Spacer()
                                
                                Image(systemName: "arrowshape.turn.up.left.fill")
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    .frame(width: 40, height: 40)
                }
                .scaledToFit()
            }
            .padding(.horizontal, 50)
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Cerrar Sesión"),
                    message: Text("¿Estás seguro que quieres cerrar la sesión?"),
                    primaryButton: .destructive(Text("Cerrar sesión"), action: {
                       authViewModel.logout()
                    }),
                    secondaryButton: .cancel()
                )
            }
            
        }
        .frame(height: 70)
        .foregroundColor(.white)
        
        /*
        .overlay(
            Rectangle()
                .fill(Color.gray)
                .frame(height: 0.5)
                .edgesIgnoringSafeArea(.horizontal), alignment: .bottom
        )
         */
    }
}





struct AdminNav_Previews: PreviewProvider {
    static var previews: some View {
        AdminNav(authViewModel: AuthViewModel(), showAdminView: .constant(false), showRegisterView: .constant(false), user: User(id: "", name: "", email: "", isAdmin: false, image: ""))
    }
}
