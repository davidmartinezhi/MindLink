//
//  AdminMenuView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 06/06/23.
//

import SwiftUI

struct AdminMenuView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    var user: User
    @State private var name: String
    @State private var email: String
    @State private var isEditing = false

    @State private var showLogoutAlert = false

    init(authViewModel: AuthViewModel, user: User) {
        self.authViewModel = authViewModel
        self.user = user
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
    }
    
    var body: some View {
        VStack {
            
            //Logout button
            HStack{
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
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(maxWidth: 170)
                
                Spacer()
            }
            
            VStack {
                Image(systemName: "person.circle")
                    .font(.system(size: 80))
                    //.foregroundColor(Color(.label))
                    .foregroundColor(.gray)
                
                Text(name)
                    .font(.title)
                    .bold()
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            .frame(maxHeight: 150)
            //.padding(.top, 50)
            
            VStack{
                Form {
                    Section(header: Text("Información")) {
                        TextField("Nombre", text: $name)
                        TextField("email", text: $email)
                    }
                }
            }
            .frame(maxHeight: 300)
            
            //Spacer()
            VStack(alignment: .leading, spacing: 10) {
                
                HStack{
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
                    
                    
                    //Guardar
                    Button(action: {
                        self.showLogoutAlert.toggle()
                    }) {
                        HStack {
                            Text("Guardar")
                                .font(.headline)
                            
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                //.padding(.bottom)

                /**
                Button(action: {
                    self.showLogoutAlert.toggle()
                }) {
                    HStack {
                        Text("Cerrar sesión")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "arrowshape.turn.up.left.fill")
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.red)
                 */
            }
            .padding()
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
            
            Spacer()
        }
        .padding()
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView(authViewModel: AuthViewModel() ,user: User(id: "", name: "", email: "", isAdmin: false))
    }
}
