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
    @State var userBeingRemoved: User? = nil // user's id.
    
    @State var showErrorMessage: Bool = false
    @State var errorMessage: String = ""
    
    @State var executeWithPasswordConfirmation: ((String) -> Void)? = nil
    
    let imageHandler: FirebaseAlmacenamiento = FirebaseAlmacenamiento()
    
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
                                UserView(user: User.newEmptyUser(), userBeingEdited: $userBeingEdited) { user, userPickedImage, userPassword, userOperation in
                                    self.makeUserOperation(withUser: user, userPickedImage: userPickedImage, userPassword: userPassword, userOperation: userOperation)
                                }
                            }
                            
                            let userArray: [User] = filterUsers(users: sortUsersByName(users: Array(users.values)), searchText: searchText, userType: pickedUserType)
                            ForEach(userArray) { user in
                                UserView(user: user, userBeingEdited: $userBeingEdited) { user, userPickedImage, userPassword, userOperation in
                                    self.makeUserOperation(withUser: user, userPickedImage: userPickedImage, userPassword: userPassword, userOperation: userOperation)
                                }
                            }
                            
                            if userArray.isEmpty && (!searchText.isEmpty || pickedUserType != .baseUserOrAdminUser) {
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
        .customConfirmAlert(title: "Eliminar usuario", message: "El usuario será eliminado para siempre", isPresented: $isDeletingUser) {
            self.removeUserAndItsImage(userToRemove: userBeingRemoved!)
        }
        .customAlert(title: "Error", message: errorMessage, isPresented: $showErrorMessage)
    }
    
    func makeUserOperation(withUser user: User, userPickedImage: UIImage?, userPassword: String?, userOperation: UserOperation) -> Void {
        switch userOperation {
        case .addMe:
            self.addUser(userToAdd: user, userPickedImage: userPickedImage, withPassword: userPassword!)
        case .removeMe:
            self.removeUser(userToRemove: user)
        case .saveMe:
            self.saveUser(userToSave: user, userPickedImage: userPickedImage)
        case .cancelMyCreation:
            self.creatingUser = false
        }
    }
    
    func showError(errorMessage: String) -> Void {
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
