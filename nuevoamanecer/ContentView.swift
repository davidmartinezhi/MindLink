//
//  ContentView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    //@State var hiddenNavBar = false
    //@State private var showAdminMenu = false

    func initialFetch() {
        authViewModel.fetchCurrentUser()
    }

    var body: some View {
        VStack {
            if let user = authViewModel.user {
                VStack {
                    // Contenido principal de la vista
                    AdminView(authViewModel: authViewModel, user: user)
                }
                
            } else {
                AuthView(authViewModel: authViewModel)  // Si no hay usuario, muestra la vista de inicio de sesión
            }
        }
        .onAppear(perform: initialFetch)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
