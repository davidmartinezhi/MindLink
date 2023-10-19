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
    @State var users: [User] = []
    // filteredUsers: arreglo de tuplas. Cada tupla contiene un usuario y el índice del usuario en el arreglo de usuarios 'users'.
    @State var filteredUsers: [(Int, User)] = []
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
                            .onChange(of: searchText) { _ in
                                performUserFiltering()
                            }
                        
                        Spacer()
                        
                        ButtonWithImageView(text: "Nuevo Usuario", systemNameImage: "plus.circle.fill", imagePosition: .left, isDisabled: creatingUser) {
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
                        .onChange(of: pickedUserType) { _ in
                            performUserFiltering()
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, leadingPadding)
                    .padding(.trailing, trailingPadding)
                    .padding(.vertical, 10)
                    .frame(height: 70)
                    
                    Divider()
                    
                    ScrollView  {
                        VStack(spacing: 0) {
                            if creatingUser {
                                NewUserView(userBeingEdited: $userBeingEdited) { userOperation, userOperationData in
                                    self.makeUserOperation(userOperation: userOperation, userOperationData: userOperationData)
                                }
                            }
                                                                                      
                            ForEach(filteredUsers, id: \.1.id) { (index, _) in
                                UserView(user: $users[index], userBeingEdited: $userBeingEdited) { userOperation, userOperationData in
                                    self.makeUserOperation(userOperation: userOperation, userOperationData: userOperationData)
                                }
                            }
                            
                            if filteredUsers.isEmpty && (!searchText.isEmpty || pickedUserType != .baseUserOrAdminUser) {
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
                    users = fetchedUsers!
                    filteredUsers = sortUsersByName(userIndexes: userArrayToIndexesArray(users: users))
                }
            }
        }
        .customConfirmAlert(title: "Eliminar usuario", message: "El usuario será eliminado para siempre", isPresented: $isDeletingUser) {
            self._removeUser(userToRemove: userBeingRemoved!)
        }
        .customAlert(title: "Error", message: errorMessage, isPresented: $showErrorMessage)
    }
    
    func makeUserOperation(userOperation: UserOperation, userOperationData: UserOperationData) -> Void {
        switch userOperation {
        case .addMe:
            self.addUser(userToAdd: userOperationData.userData, withImage: userOperationData.imageToAdd, withPassword: userOperationData.userPassword!)
        case .removeMe:
            self.removeUser(userToRemove: userOperationData.userData)
        case .editMe:
            self.editUser(userToEdit: userOperationData.userData, withImage: userOperationData.imageToAdd, removingImage: userOperationData.imageToRemove, runAtSuccessfulEdit: userOperationData.runAtSuccess)
        case .cancelMyCreation:
            self.creatingUser = false
        }
    }
    
    func showError(errorMessage: String) -> Void {
        self.errorMessage = errorMessage
        self.showErrorMessage = true
    }
    
    func performUserFiltering() -> Void {
        self.filteredUsers = filterUsers(userIndexes: sortUsersByName(userIndexes: userArrayToIndexesArray(users: users)), searchText: searchText, userType: pickedUserType)
    }
}

func buildUserImageName(user: User) -> String {
    return "User_\(user.name.removeWhitespaces())_\(UUID().uuidString)"
}

enum UserOperation {
    case addMe, removeMe, editMe, cancelMyCreation
}

enum UserType: String, CaseIterable, Identifiable {
    case baseUserOrAdminUser = "Todos"
    case baseUser = "No Administradores"
    case adminUser = "Administradores"
    var id: Self { self }
}
