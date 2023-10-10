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
    // @State var userSnapshots: [String:User] = [:]
    @State var userBeingEdited: String? = nil // user's id.
    @State var creatingUser: Bool = false
    var userVM: UserViewModel = UserViewModel()
    
    @State var searchText: String = ""
    @State var pickedUserType: UserType = .baseUserOrAdminUser
    
    @State var isDeletingUser: Bool = false
    @State var userBeingDeleted: String? = nil // user's id.
    
    @State var showErrorMessage: Bool = false
    @State var errorMessage: String = ""
    
    @State var executeWithPasswordConfirmation: ((String) -> Void)? = nil
    
    let imageHanlder: FirebaseAlmacenamiento = FirebaseAlmacenamiento()
    
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
                        
                        Picker("Filtro", selection: $pickedUserType) {
                            ForEach(UserType.allCases) { filter in
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
                                UserView(user: User.newEmptyUser(), userBeingEdited: $userBeingEdited) { userData, userPickedImage, userOperation in
                                    self.makeUserOperation(userData: userData, userPickedImage: userPickedImage, userOperation: userOperation)
                                }
                            }
                            
                            let userArray: [User] = filterUsers(users: sortUsersByName(users: Array(users.values)), searchText: searchText, userType: pickedUserType)
                            ForEach(userArray) { user in
                                UserView(user: user, userBeingEdited: $userBeingEdited) { userData, userPickedImage, userOperation in
                                    self.makeUserOperation(userData: userData, userPickedImage: userPickedImage, userOperation: userOperation)
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
                    users = userArrayToDict(users: fetchedUsers!)
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
    
    func makeUserOperation(userData: User, userPickedImage: UIImage?, userOperation: UserOperation) -> Void {
        switch userOperation {
        case .addMe:
            self.addUser(userData, userPickedImage: userPickedImage)
        case .removeMe:
            self.removeUser(userData)
        case .saveMe:
            self.saveUser(userData, userPickedImage: userPickedImage)
        case .cancelMyCreation:
            self.creatingUser = false
        }
    }
    
    private func addUser(_ user: User, userPickedImage: UIImage?) -> Void {
        executeWithPasswordConfirmation = { currUserPassword in 
            Task {
                var moddedUser: User = user
                if userPickedImage != nil {
                    if let imageUrl: URL = await imageHanlder.uploadImage(image: userPickedImage!, name: buildUserImageName(user: user)) {
                        moddedUser.image = imageUrl.absoluteString
                    } else {
                        showError(errorMessage: "Error al guardar la imagén seleccionada")
                        return
                    }
                }
                
                let userCreationResult: AuthActionResult = await authVM.createNewAuthAccount(email: moddedUser.email, password: "12345678", currUserPassword: currUserPassword)
                
                if userCreationResult.success {
                    self.userVM.addUserWithCustomId(user: moddedUser, userId: userCreationResult.userId!) { error in
                        if error != nil{
                            // Error al añadir usuario.
                            showError(errorMessage: "Error en la creación del usuario")
                        } else {
                            moddedUser.id = userCreationResult.userId!
                            self.users[userCreationResult.userId!] = moddedUser
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
    
    private func saveUser(_ user: User, userPickedImage: UIImage?) -> Void {
        Task {
            var moddedUser: User = user
            if userPickedImage != nil {
                if let imageUrl: URL = await imageHanlder.uploadImage(image: userPickedImage!, name: buildUserImageName(user: user)) {
                    moddedUser.image = imageUrl.absoluteString
                } else {
                    showError(errorMessage: "Error al guardar la imagén seleccionada")
                    return
                }
            }
            
            self.userVM.editUser(userId: moddedUser.id!, newUserValue: moddedUser) { error in
                if error != nil {
                    showError(errorMessage: "Error al guardar los cambios")
                } else {
                    self.users[moddedUser.id!] = moddedUser
                    self.userBeingEdited = nil
                }
            }
        }
    }
        
    private func showError(errorMessage: String) -> Void {
        self.errorMessage = errorMessage
        self.showErrorMessage = true
    }
}

func buildUserImageName(user: User) -> String {
    return "User_\(user.name.removeWhitespaces())_\(UUID().uuidString)"
}

enum UserOperation {
    case addMe, removeMe, saveMe, cancelMyCreation
}

enum UserType: String, CaseIterable, Identifiable {
    case baseUserOrAdminUser = "Todos"
    case baseUser = "No Administradores"
    case adminUser = "Administradores"
    var id: Self { self }
}
