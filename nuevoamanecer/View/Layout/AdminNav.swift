//
//  AdminNav.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 05/06/23.
//

import SwiftUI

struct AdminNav: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @State var showNavBar = true
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            AdminView()
                .padding(.top)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(showNavBar)
                .toolbar {
                    // Logo en el lado izquierdo
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                    }
                    // Botón de configuración en el lado derecho
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Acción del botón aquí
                            self.showLogoutAlert.toggle()
                        }) {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("Logout"),
                        message: Text("¿Estás seguro que quieres cerrar la sesión?"),
                        primaryButton: .destructive(Text("Logout"), action: {
                            authViewModel.logout()
                        }),
                        secondaryButton: .cancel()
                    )
                }
        }
        .navigationViewStyle(.stack)
    }
}

struct AdminNav_Previews: PreviewProvider {
    static var previews: some View {
        AdminNav(authViewModel: AuthViewModel())
    }
}
