//
//  UserManagement.swift
//  nuevoamanecer
//
//  Created by emilio on 26/09/23.
//

import SwiftUI

struct UserManagement: View {
    // Variables de entorno
    @EnvironmentObject var authVM: AuthViewModel
    
    // Variables de la vista
    @State var users: [String:User] = [:]
    @State var userBeingEdited: String? = nil // user's id.
    @State var creatingUser: Bool = false
    var userVM: UserViewModel = UserViewModel()
    
    @State var searchText: String = ""
    @State var pickedUserFilter: UserFilter = .todos
    
    @State var isDeletingUser: Bool = false
    @State var userBeingDeleted: String? = nil // user's id.
    
    @State var showErrorMessage: Bool = false
    @State var errorMessage: String = ""
    
    @State var executeWithPasswordConfirmation: ((String) -> Void)? = nil
    
    var body: some View {
        let leadingPadding: CGFloat = 100
        let trailingPadding: CGFloat = 150
        
        GeometryReader { geo in
            ZStack {
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
                    
                    HStack {
                        Text("Filtrado")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                        
                        Divider()
                        
                        Picker("Filtro", selection: $pickedUserFilter) {
                            ForEach(UserFilter.allCases) { filter in
                                Text(filter.rawValue)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
                    .padding(.vertical, 10)
                    .frame(height: 70)
                    
                    Divider()
                    
                    ScrollView  {
                        LazyVStack(spacing: 0) {
                            if creatingUser {                                
                                UserView(user: User.newEmptyUser(), isBeingEdited: true) { userData, userOperation in
                                    self.makeUserOperation(userData: userData, userOperation: userOperation)
                                }
                            }
                            
                            let userArray: [User] = arrangeUsers(users: Array(users.values), searchText: searchText, filter: pickedUserFilter)
                            ForEach(userArray) { user in
                                UserView(user: user, isBeingEdited: user.id! == userBeingEdited) { userData, userOperation in
                                    self.makeUserOperation(userData: userData, userOperation: userOperation)
                                }
                            }
                            
                            if userArray.isEmpty {
                                Text("Sin resultados")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.vertical, 200)
                            }
                        }
                    }
                }
                
                if executeWithPasswordConfirmation != nil {
                    PasswordInputWindowView(action: $executeWithPasswordConfirmation)
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
        .customConfirmAlert(title: "Eliminar Usuario", message: "El usuario será eliminado para siempre", isPresented: $isDeletingUser) {
            self.userVM.removeUser(userId: userBeingDeleted!) { error in
                if error != nil {
                    // Error al eliminar usuario.
                } else {
                    self.users.removeValue(forKey: userBeingDeleted!)
                }
            }
        }
        .customAlert(title: "Error", message: errorMessage, isPresented: $showErrorMessage)
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
        executeWithPasswordConfirmation = { currUserPassword in 
            Task {
                let userCreationResult: AuthActionResult = await authVM.createNewAuthAccount(email: user.email, password: "12345678", currUserPassword: currUserPassword)
                
                if userCreationResult.success {
                    self.userVM.addUserWithCustomId(user: user, userId: userCreationResult.userId!) { error in
                        if error != nil{
                            // Error al añadir usuario.
                            errorMessage = "Error en la creación del usuario"
                            showErrorMessage = true
                        } else {
                            var userWithId: User = user
                            userWithId.id = userCreationResult.userId!
                            self.users[userCreationResult.userId!] = userWithId
                            self.userBeingEdited = nil
                            self.creatingUser = false
                        }
                    }
                } else {
                    // Error al añadir al nuevo usuario a Auth.
                    showError(errorMessage: userCreationResult.errorMessage!)
                }
            }
        }
    }
    
    private func removeUser(_ user: User) -> Void {
        if user.id != nil {
            userBeingDeleted = user.id!
            isDeletingUser = true
        }
    }
    
    private func saveUser(_ user: User) -> Void {
        self.userVM.editUser(userId: user.id!, newUserValue: user) { error in
            if error != nil {
                showError(errorMessage: "Error al guardar los cambios")
            } else {
                self.users[user.id!] = user
                self.userBeingEdited = nil
            }
        }
    }

    private func toggleUserEditState(_ user: User) -> Void {
        if user.id != nil {
            if self.userBeingEdited != nil {
                
            }
            self.userBeingEdited = self.userBeingEdited == user.id! ? nil : user.id!
        }
    }
    
    private func cancelUserCreation() -> Void {
        self.creatingUser = false
    }
    
    private func showError(errorMessage: String) -> Void {
        self.errorMessage = errorMessage
        self.showErrorMessage = true
    }
}


func arrangeUsers(users: [User], searchText: String, filter: UserFilter) -> [User] {
    let usersWithSortAndFilter: [User] = users.sorted{$0.name < $1.name}.filter { user in
        switch filter {
        case .todos:
            return true
        case .admin:
            return user.isAdmin == true
        case .noAdmin:
            return user.isAdmin == false 
        }
    }
    
    let cleanedSearchText: String = searchText.cleanForSearch()
    
    return searchText.isEmpty ? usersWithSortAndFilter : usersWithSortAndFilter.filter {
        ($0.name + $0.email).cleanForSearch().contains(cleanedSearchText)
    }
}

enum UserOperation {
    case addMe, removeMe, saveMe, toggleMyEditState, cancelMyCreation
}

enum UserFilter: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case admin = "Administradores"
    case noAdmin = "No Administradores"
    var id: Self { self }
}
