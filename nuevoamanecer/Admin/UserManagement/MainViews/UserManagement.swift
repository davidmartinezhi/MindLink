//
//  UserManagement.swift
//  nuevoamanecer
//
//  Created by emilio on 26/09/23.
//

import SwiftUI

enum UserOperation {
    case addMe, removeMe, saveMe, toggleMyEditState, cancelMyCreation
}

struct UserManagement: View {
    // Variables de entorno
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var currentUser: UserWrapper
    @EnvironmentObject var navPath: NavigationPathWrapper
    
    // Variables de la vista
    @State var users: [String:User] = [:]
    @State var userBeingEdited: String? = nil // user's id.
    @State var creatingUser: Bool = false
    var userVM: UserViewModel = UserViewModel()
    
    @State var searchText: String = ""
    
    var body: some View {
        let leadingPadding: CGFloat = 100
        let trailingPadding: CGFloat = 150
        
        GeometryReader { geo in
            VStack {
                HStack(alignment: .center) {
                    SearchBarView(searchText: $searchText, placeholder: "Buscar usuario", searchBarWidth: 300)
                    
                    Spacer()
                    
                    ButtonWithImageView(text: "Nuevo Usuario", systemNameImage: "plus", isDisabled: creatingUser) {
                        creatingUser = true
                        userBeingEdited = nil
                    }
                }
                .padding(.leading, leadingPadding)
                .padding(.trailing, trailingPadding)
                
                Divider()
                
                ScrollView  {
                    LazyVStack(spacing: 0) {
                        if creatingUser {
                            let creatingUserBlue: Color = Color(red: 37, green: 139, blue: 247)
                            
                            UserView(user: User.newEmptyUser(), isBeingEdited: true, backgroundColorWhenEditing: creatingUserBlue) { userData, userOperation in
                                self.makeUserOperation(userData: userData, userOperation: userOperation)
                            }
                        }
                        
                        let userArray: [User] = searchText.isEmpty ? users.values.sorted{$0.name < $1.name} : users.values.sorted{$0.name < $1.name}.filter {($0.name + $0.email).cleanForSearch().contains(searchText.cleanForSearch())}
                        
                        ForEach(userArray) { user in
                            UserView(user: user, isBeingEdited: user.id! == userBeingEdited) { userData, userOperation in
                                self.makeUserOperation(userData: userData, userOperation: userOperation)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            userVM.getAllUsers { error, fetchedUsers in
                if error != nil || fetchedUsers == nil {
                    // Error al obtener usuarios
                } else {
                    users = Dictionary(uniqueKeysWithValues: fetchedUsers!.map {($0.id!, $0)})
                }
            }
        }
    }
    
    func makeUserOperation(userData: User, userOperation: UserOperation) -> Void {
        switch userOperation {
        case .addMe:
            self.addUser(userData)
        case .removeMe:
            self.removeUser(userData)
        case .saveMe:
            self.saveUser(userData)
        case .toggleMyEditState:
            self.toggleUserEditState(userData)
        case .cancelMyCreation:
            self.cancelUserCreation()
        }
    }
    
    private func addUser(_ user: User) -> Void {
        self.userVM.addUser(user: user) { error, id in
            if error != nil || id == nil {
                // Error al añadir usuario.
            } else {
                var moddedUser: User = user
                moddedUser.id = id!
                self.users[id!] = moddedUser
                self.userBeingEdited = nil
                self.creatingUser = false
            }
        }
    }
    
    private func removeUser(_ user: User) -> Void {
        self.userVM.removeUser(userId: user.id!) { error in
            if error != nil {
                // Error al eliminar usuario.
            } else {
                self.users.removeValue(forKey: user.id!)
            }
        }
    }
    
    private func saveUser(_ user: User) -> Void {
        self.userVM.editUser(userId: user.id!, newUserValue: user) { error in
            if error != nil {
                // Error al editar usuario
            } else {
                self.users[user.id!] = user
                self.userBeingEdited = nil
            }
        }
    }
    
    private func toggleUserEditState(_ user: User) -> Void {
        if user.id != nil {
            self.users[user.id!] = user
            self.userBeingEdited = self.userBeingEdited == user.id! ? nil : user.id!
        }
    }
    
    private func cancelUserCreation() -> Void {
        self.creatingUser = false
    }
}
