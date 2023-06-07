//
//  AdminMenuView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 06/06/23.
//

import SwiftUI

struct AdminMenuView: View {
    
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
            VStack {
                Image(systemName: "person.fill") // Replace with user profile picture
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Text(name)
                    .font(.title)
                    .bold()
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            .padding(.top, 50)
            
            VStack{
                Form {
                    Section(header: Text("Información")) {
                        TextField("Nombre", text: $name)
                        TextField("email", text: $email)
                    }
                }
            }
            
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
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
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.blue)
                
                Button(action: {
                    self.showLogoutAlert.toggle()
                }) {
                    HStack {
                        Text("Cerrar sesión")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right.circle.fill")
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.red)
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
