//
//  UserView.swift
//  nuevoamanecer
//
//  Created by emilio on 26/09/23.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var currentUser: UserWrapper
    
    @Binding var user: User
    @State var userPassword: String = ""
    @Binding var userBeingEdited: String?
    @State var userSnapshot: User
    var makeUserOperation: (UserOperation, UserOperationData) -> Void
        
    @State var pickedUserImage: UIImage? = nil
    
    var isNewUser: Bool {self.user.id == nil}
    var isBeingEdited: Bool {self.user.id == self.userBeingEdited}

    init(user: Binding<User>, userBeingEdited: Binding<String?>, makeUserOperation: @escaping (UserOperation, UserOperationData) -> Void){
        self._user = user
        self._userSnapshot = State(initialValue: user.wrappedValue)
        self._userBeingEdited = userBeingEdited
        self.makeUserOperation = makeUserOperation
    }
    
    var body: some View {
        let leadingPadding: CGFloat = 100
        let trailingPadding: CGFloat = 150
        
        VStack {
            HStack(alignment: .center) {
                HStack(spacing: 35) {
                    VStack {
                        Text(isNewUser ? "Usuario Nuevo" : (currentUser.id == user.id ? "Usuario Actual" : ""))
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .opacity(isNewUser || currentUser.id == user.id ? 1 : 0)
                        
                        UserImageEditView(user: $user, userSnaphot: $userSnapshot, pickedUserImage: $pickedUserImage, isBeingEdited: isBeingEdited || isNewUser)
                    }
                                         
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center, spacing: 10) {
                            DualTextFieldView(text: $user.name, placeholder: "Nombre", editing: isNewUser || isBeingEdited, fontSize: 20)
                                .bold()
                            ChangeIndicatorView(showIndicator: user.name != userSnapshot.name && !isNewUser)
                            InvalidInputView(show: !user.name.isEmpty && !user.hasValidName(), text: "Nombre inválido")
                        }
                        
                        HStack(alignment: .center, spacing: 10) {
                            DualTextFieldView(text: $user.email, placeholder: "Correo", editing: isNewUser, fontSize: 15)
                            ChangeIndicatorView(showIndicator: user.email != userSnapshot.email && !isNewUser)
                            InvalidInputView(show: !user.email.isEmpty && !user.hasValidEmail(), text: "Correo inválido")
                        }
                        
                        if isNewUser {
                            HStack(alignment: .center, spacing: 10) {
                                DualTextFieldView(text: $userPassword, placeholder: "Contraseña", editing: isNewUser, fontSize: 15)
                                InvalidInputView(show: !userPassword.isEmpty && !userPassword.isValidPassword(), text: "Contraseña inválida")
                            }
                        }
                        
                        HStack(spacing: 10) {
                            Text("Administrador: ")
                                .font(.system(size: 15))
                            DualChoiceView(choice: $user.isAdmin, labels: ("Sí", "No"), isBeingEdited: isNewUser || isBeingEdited, isDisabled: !isBeingEdited)
                            ChangeIndicatorView(showIndicator: user.isAdmin != userSnapshot.isAdmin && !isNewUser)
                        }
                    }
                }
                
                Spacer()
                
                let runAtCancel: ()->Void = {
                    if isNewUser {
                        makeUserOperation(.cancelMyCreation, UserOperationData(userData: user))
                    } else {
                        userBeingEdited = nil
                    }
                    
                    self.pickedUserImage = nil
                    self.user = self.userSnapshot
                }
                
                let runAtSave: ()->Void = {
                    if isNewUser {
                        makeUserOperation(.addMe, UserOperationData(userData: user, imageToAdd: pickedUserImage, userPassword: userPassword))
                    } else {
                        let runAtSuccess: ()->Void = {
                            pickedUserImage = nil
                            userSnapshot = user
                        }
                        
                        makeUserOperation(.editMe, UserOperationData(userData: user, imageToAdd: pickedUserImage, imageToRemove: user.image == nil && userSnapshot.image != nil ? userSnapshot.image : nil, runAtSuccess: runAtSuccess))
                    }
                }
                                                
                if user.id != currentUser.id {
                    let disableSave: Bool = !user.isValidUser() || (user == userSnapshot && pickedUserImage == nil) || (isNewUser && !userPassword.isValidPassword())
    
                    EditPanelView(isBeingEdited: isBeingEdited || isNewUser,
                                  isNewUser: isNewUser,
                                  disableSave: disableSave,
                                  runAtEdit: {self.userBeingEdited = self.user.id},
                                  runAtDelete: {makeUserOperation(.removeMe, UserOperationData(userData: user))},
                                  runAtSave: runAtSave,
                                  runAtCancel: runAtCancel)
                }
            }
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
            .padding(.vertical, 20)
            
            Divider()
        }
        .background(isBeingEdited || isNewUser ? Color(red: 0.95, green: 0.95, blue: 0.95) : .white)
        .onChange(of: userBeingEdited) { _ in
            if  user.id != userBeingEdited && userBeingEdited != nil {
                user = userSnapshot
            }
        }
    }
}

struct InvalidInputView: View {
    let show: Bool
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.gray)
            .opacity(show ? 1 : 0)
    }
}
