//
//  ContentView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authVM: AuthViewModel = AuthViewModel()
    @StateObject var currentUser: UserWrapper = UserWrapper()
    @StateObject var navPath = NavigationPathWrapper() // Contiene una instancia de NavigationPath, es proveida como variable de ambiente.
    var userVM: UserViewModel = UserViewModel()

    var body: some View {
        NavigationStack(path: $navPath.path) {
            AuthView()
                .navigationDestination(for: NavigationDestination<AdminView>.self) { destination in
                    destination.content
                }
                .navigationDestination(for: NavigationDestination<LoginView>.self) { destination in
                    destination.content
                }
                .navigationDestination(for: NavigationDestination<PatientView>.self) { destination in
                    destination.content
                }
                .navigationDestination(for: NavigationDestination<SingleCommunicator>.self) { destination in
                    destination.content
                }
                .navigationDestination(for: NavigationDestination<DoubleCommunicator>.self) { destination in
                    destination.content
                }
                .navigationDestination(for: NavigationDestination<PictogramEditor>.self) { destination in
                    destination.content
                }
        }
        .environmentObject(authVM)
        .environmentObject(currentUser)
        .environmentObject(navPath)
        .onAppear {
            if authVM.loggedInAuthUserId() != nil {
                userVM.getUser(userId: authVM.loggedInAuthUserId()!) { error, user in
                    if error != nil || user == nil {
                        // Error al obtener usuario
                    } else {
                        currentUser.setUser(user: user!)
                        navPath.push(NavigationDestination<AdminView>(content: AdminView()))
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
