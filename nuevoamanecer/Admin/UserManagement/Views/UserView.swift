//
//  UserView.swift
//  nuevoamanecer
//
//  Created by emilio on 26/09/23.
//

import SwiftUI
import Kingfisher

struct InvalidInputView: View {
    let show: Bool
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.gray)
            .opacity(show ? 1 : 0)
    }
}

struct UserView: View {
    @EnvironmentObject var currentUser: UserWrapper
    
    @State var user: User
    var userSnapshot: User
    var isBeingEdited: Bool
    var backgroundColorWhenEditing: Color
    var makeUserOperation: (User, UserOperation) -> Void
    
    var isNewUser: Bool
    
    init(user: User, isBeingEdited: Bool, backgroundColorWhenEditing: Color = Color(red: 0.95, green: 0.95, blue: 0.95), makeUserOperation: @escaping (User, UserOperation) -> Void){
        self._user = State(initialValue: user)
        self.userSnapshot = user
        self.isBeingEdited = isBeingEdited
        self.backgroundColorWhenEditing = backgroundColorWhenEditing
        self.makeUserOperation = makeUserOperation
        
        self.isNewUser = user.id == nil
    }
    
    var body: some View {
        let leadingPadding: CGFloat = 100
        let trailingPadding: CGFloat = 150
        
        VStack {
            HStack(alignment: .center) {
                HStack(spacing: 35) {
                    VStack {
                        KFImage(URL(string: user.image ?? ""))
                            .placeholder{
                                let nameComponents: [String] = user.name.splitAtWhitespaces()
                                ImagePlaceholderView(firstName: nameComponents.getElementSafely(index: 0) ?? "",
                                                     lastName: nameComponents.getElementSafely(index: 1) ?? "")
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        Text(isNewUser ? "Usuario Nuevo" : (currentUser.id == user.id ? "Usuario Actual" : ""))
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .opacity(isNewUser || currentUser.id == user.id ? 1 : 0)
                    }
                                         
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center, spacing: 10) {
                            DualTextFieldView(text: $user.name, placeholder: "Nombre", editing: isBeingEdited, fontSize: 20)
                                .bold()
                            ChangeIndicatorView(showIndicator: user.name != userSnapshot.name && !isNewUser)
                            InvalidInputView(show: !user.hasValidName(), text: "Nombre inválido")
                        }
                        
                        HStack(alignment: .center, spacing: 10) {
                            DualTextFieldView(text: $user.email, placeholder: "Correo", editing: isBeingEdited, fontSize: 15)
                            ChangeIndicatorView(showIndicator: user.email != userSnapshot.email && !isNewUser)
                            InvalidInputView(show: !user.hasValidEmail(), text: "Correo inválido")
                        }
                        
                        HStack(spacing: 10) {
                            Text("Admin: ")
                                .font(.system(size: 15))
                            DualChoiceView(choice: $user.isAdmin, labels: ("Sí", "No"), isBeingEdited: isBeingEdited, isDisabled: !isBeingEdited)
                            ChangeIndicatorView(showIndicator: user.isAdmin != userSnapshot.isAdmin && !isNewUser)
                        }
                    }
                }
                
                Spacer()
                
                let runAtCancel: ()->Void = {
                    if isNewUser {
                        makeUserOperation(user, .cancelMyCreation)
                    } else {
                        makeUserOperation(user, .toggleMyEditState)
                    }
                    self.user = self.userSnapshot
                }
                
                EditPanelView(isBeingEdited: isBeingEdited,
                              isNewUser: isNewUser,
                              disableDelete: currentUser.id == user.id || isNewUser,
                              disableSave: user == userSnapshot || !user.isValidUser(),
                              runAtEdit: {makeUserOperation(user, .toggleMyEditState)},
                              runAtDelete: {makeUserOperation(user, .removeMe)},
                              runAtSave: isNewUser ? {makeUserOperation(user, .addMe)} : {makeUserOperation(user, .saveMe)},
                              runAtCancel: runAtCancel)
            }
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
            .frame(height: 180)
            
            Divider()
        }
        .background(isBeingEdited ? backgroundColorWhenEditing : .white)
        .onChange(of: isBeingEdited) { newValue in
            user = userSnapshot
        }
    }
}
