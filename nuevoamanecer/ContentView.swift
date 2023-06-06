//
//  ContentView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var authViewModel = AuthViewModel()
    @State var hiddenNavBar = false
    @State private var showLogoutAlert = false

    var body: some View {
         VStack {
             if let _ = authViewModel.user {
                 VStack {
                     // Barra de navegación personalizada
                     if(!hiddenNavBar){
                         AdminNav(authViewModel: authViewModel, showLogoutAlert: $showLogoutAlert)
                     }
                    
                     // Contenido principal de la vista
                     AdminView()
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
             } else {
                 AuthView(authViewModel: authViewModel)  // Si no hay usuario, muestra la vista de inicio de sesión
             }
         }
     }
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
