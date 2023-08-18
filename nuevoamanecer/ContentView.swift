//
//  ContentView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

class AppLock: ObservableObject {
    @Published var isLocked: Bool = false
}

struct ContentView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    //@State var hiddenNavBar = false
    //@State private var showAdminMenu = false
    @State private var showAdminView = false
    @State private var showRegisterView = false
    
    @StateObject var appLock: AppLock = AppLock()

    func initialFetch() {
        authViewModel.fetchCurrentUser()
    }

    var body: some View {
        VStack {
            if let user = authViewModel.user {
                VStack {
                    // Contenido principal de la vista
                    AdminNav(authViewModel:authViewModel, showAdminView: $showAdminView, showRegisterView: $showRegisterView, user: user)
                    AdminView(authViewModel: authViewModel, user: user)
                }
                .sheet(isPresented: $showAdminView){
                    AdminMenuView(authViewModel: authViewModel, user: user)
                }
                .sheet(isPresented: $showRegisterView){
                    RegisterView(authViewModel: authViewModel)
                }
                .environmentObject(appLock)
                
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
