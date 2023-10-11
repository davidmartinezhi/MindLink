//
//  AdminNav.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 05/06/23.
//

import SwiftUI
import Kingfisher

struct AdminNav: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var currentUser: UserWrapper
    @EnvironmentObject var navPath: NavigationPathWrapper
    
    @Binding var showAdminView: Bool
    @Binding var showRegisterView: Bool
    
    @State private var upload_image: UIImage?
    @State private var imageURL = URL(string: "")
    @State private var storage = FirebaseAlmacenamiento()
    
    @State private var showLogoutAlert = false
    
    @EnvironmentObject var pathWrapper: NavigationPathWrapper
    @EnvironmentObject var currentUserWrapper: UserWrapper
        
    var body: some View {
        ZStack {
            HStack {
                Image("logo_name")
                    .resizable()
                    //.renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .padding()
                
                Spacer()
                
                ZStack{
                    //No imagen
                    let userNames: [String] = currentUser.name!.splitAtWhitespaces()
                    let firstName: String =  userNames.getElementSafely(index: 0) ?? " "
                    let lastName: String = userNames.getElementSafely(index: 0) ?? " "
                    
                    if currentUser.image == nil {
                        //ImagePlaceholderView(firstName: userNames.getElementSafely(index: 0) ?? "",lastName: userNames.getElementSafely(index: 0) ?? "", radius: 100, fontSize: 20)
                        Text(firstName.prefix(1) + lastName.prefix(1))
                            .textCase(.uppercase)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .frame(width: 50, height: 50)
                            .background(Color(.systemGray3))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        
                    }
                    //Imagen previamente subida
                    else{
                        ZStack{
                            KFImage(URL(string: currentUser.image!))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .cornerRadius(128)
                                .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Menu("           "){
                        // boton para ir a la vista de perfil
                        Button(action: { showAdminView = true }) {
                            HStack {
                                Text("Mi perfil")
                                    .font(.system(size: 16))
                            }
                        }
                        
                        // solo usuarios administradores pueden crear otro usuario
                        if (currentUser.isAdmin! == true) {
                            // boton para ir a la vista de registro
                            Button(action: { showRegisterView = true }) {
                                HStack {
                                    Text("Registrar Usuario")
                                        .font(.system(size: 16))
                                }
                            }
                        }
                        
                        // solo usuarios administradores pueden crear otro usuario
                        if (currentUser.isAdmin! == true) {
                            // boton para ir a la vista de registro
                            Button(action: { navPath.push(NavigationDestination(content: UserManagement())) }) {
                                HStack {
                                    Text("Administración de Usuarios")
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
                    .frame(width: 50, height: 50)
                }
                .frame(width: 50, height: 50)
            }
            .padding(.horizontal, 50)
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Cerrar Sesión"),
                    message: Text("¿Estás seguro que quieres cerrar la sesión?"),
                    primaryButton: .destructive(Text("Cerrar sesión"), action: {
                        // logout
                        let result: AuthActionResult = authVM.logout()
                        
                        if result.success {
                            pathWrapper.returnToRoot()
                        } else {
                            // Error al cerrar sesión.
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
            
        }
        .frame(height: 50)
        .foregroundColor(.white)
        .padding(.top, 20)
        
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
