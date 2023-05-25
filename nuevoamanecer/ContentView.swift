//
//  ContentView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct ContentView: View {
    //@ObservedObject var authViewModel = AuthViewModel()

    var body: some View {
        VStack {
            
            /*
            if let user = authViewModel.user {
                if user.isAdmin {
                    HomeView(authViewModel: authViewModel)  // Si el usuario es un admin, muestra la vista de búsqueda
                } else {
                    //HomeView(authViewModel: authViewModel)   // Si el usuario no es un admin, muestra la vista de perfil del niño
                }
            } else {
                AuthView(authViewModel: authViewModel)  // Si no hay usuario, muestra la vista de inicio de sesión
            }
        }
        .onAppear {
            Task.init {
                await authViewModel.getCurrentUser()
            }
             */
            
            AdminView()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
