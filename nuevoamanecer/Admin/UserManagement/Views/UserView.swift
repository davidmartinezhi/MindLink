//
//  UserView.swift
//  nuevoamanecer
//
//  Created by emilio on 26/09/23.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var currentUser: UserWrapper
    
    @State var user: User
    var userSnapshot: User
    @Binding var userBeingEdited: String?
    var makeUserOperation: (User, UIImage?, UserOperation) -> Void
    
    var isBeingEdited: Bool { userBeingEdited == user.id}
    var isNewUser: Bool {user.id == nil}
    
    @State var showImagePicker: Bool = false
    @State var pickedImage: UIImage? = nil 

    init(user: User, userBeingEdited: Binding<String?>, makeUserOperation: @escaping (User, UIImage?, UserOperation) -> Void){
        self._user = State(initialValue: user)
        self.userSnapshot = user
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
                        if pickedImage != nil {
                            Image(uiImage: pickedImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            UserImageView(user: user, isBeingEdited: isBeingEdited, showImagePicker: $showImagePicker)
                        }
 
                        Text(isNewUser ? "Usuario Nuevo" : (currentUser.id == user.id ? "Usuario Actual" : ""))
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .opacity(isNewUser || currentUser.id == user.id ? 1 : 0)
                    }
                                         
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .center, spacing: 10) {
                            DualTextFieldView(text: $user.name, placeholder: "Nombre", editing: isNewUser || isBeingEdited, fontSize: 20)
                                .bold()
                            ChangeIndicatorView(showIndicator: user.name != userSnapshot.name && !isNewUser)
                            InvalidInputView(show: !user.hasValidName(), text: "Nombre Inválido")
                        }
                        
                        HStack(alignment: .center, spacing: 10) {
                            DualTextFieldView(text: $user.email, placeholder: "Correo", editing: isNewUser, fontSize: 15)
                                .autocapitalization(.none)
                            ChangeIndicatorView(showIndicator: user.email != userSnapshot.email && !isNewUser)
                            InvalidInputView(show: !user.hasValidEmail(), text: "Correo Inválido")
                        }
                        
                        HStack(spacing: 10) {
                            Text("Admin: ")
                                .font(.system(size: 15))
                            DualChoiceView(choice: $user.isAdmin, labels: ("Sí", "No"), isBeingEdited: isNewUser || isBeingEdited, isDisabled: !isBeingEdited)
                            ChangeIndicatorView(showIndicator: user.isAdmin != userSnapshot.isAdmin && !isNewUser)
                        }
                    }
                }
                
                Spacer()
                                
                let runAtCancel: ()->Void = {
                    if isNewUser {
                        makeUserOperation(user, nil, .cancelMyCreation)
                    } else {
                        userBeingEdited = nil 
                    }
                    self.user = self.userSnapshot
                }
                
                if user.id != currentUser.id {
                    EditPanelView(isBeingEdited: isBeingEdited,
                                  isNewUser: isNewUser,
                                  disableSave: !user.isValidUser() && (user == userSnapshot || pickedImage != nil),
                                  runAtEdit: {self.userBeingEdited = user.id},
                                  runAtDelete: {makeUserOperation(user, nil, .removeMe)},
                                  runAtSave: isNewUser ? {makeUserOperation(user, pickedImage, .addMe)} : {makeUserOperation(user, pickedImage, .saveMe)},
                                  runAtCancel: {runAtCancel()})
                }
                
            }
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
            .padding(.vertical, 20)
            
            Divider()
        }
        .background(isBeingEdited ? (isNewUser ? Color(red: 0.5, green: 0.5, blue: 1) : Color(red: 0.95, green: 0.95, blue: 0.95)) : .white)
        .onChange(of: userBeingEdited) { _ in
            if  user.id != userBeingEdited && userBeingEdited != nil {
                user = userSnapshot
            }
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(image: $pickedImage)
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
