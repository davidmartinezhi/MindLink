//
//  UserManagementExtensions.swift
//  nuevoamanecer
//
//  Created by emilio on 10/10/23.
//

import Foundation
import SwiftUI

extension UserManagement {
    func saveUser(userToSave: User, userPickedImage: UIImage?) -> Void {
        Task {
            var moddedUser: User = userToSave
            if userPickedImage != nil {
                if let imageUrl: URL = await self.imageHandler.uploadImage(image: userPickedImage!, name: buildUserImageName(user: moddedUser)) {
                    moddedUser.image = imageUrl.absoluteString
                } else {
                    self.showError(errorMessage: "Error al guardar la imagén seleccionada")
                    return
                }
            }
            
            self.userVM.editUser(userId: moddedUser.id!, newUserValue: moddedUser) { error in
                if error != nil {
                    self.showError(errorMessage: "Error al guardar los cambios")
                } else {
                    self.users[moddedUser.id!] = moddedUser
                    self.userBeingEdited = nil
                }
            }
        }
    }
    
    func addUser(userToAdd: User, userPickedImage: UIImage?, withPassword: String) -> Void {
        executeWithPasswordConfirmation = { currUserPassword in
            Task {
                var moddedUser: User = userToAdd
                if userPickedImage != nil {
                    if let imageUrl: URL = await imageHandler.uploadImage(image: userPickedImage!, name: buildUserImageName(user: moddedUser)) {
                        moddedUser.image = imageUrl.absoluteString
                    } else {
                        showError(errorMessage: "Error al guardar la imagén seleccionada")
                        return
                    }
                }
                
                let userCreationResult: AuthActionResult = await self.authVM.createNewAuthAccount(email: moddedUser.email, password: withPassword, currUserPassword: currUserPassword)
                
                if userCreationResult.success {
                    self.userVM.addUserWithCustomId(user: moddedUser, userId: userCreationResult.userId!) { error in
                        if error != nil{
                            // Error al añadir usuario.
                            self.showError(errorMessage: "Error en la creación del usuario")
                        } else {
                            moddedUser.id = userCreationResult.userId!
                            self.users[userCreationResult.userId!] = moddedUser
                            self.userBeingEdited = nil
                            self.creatingUser = false
                        }
                    }
                } else {
                    // Error al añadir al nuevo usuario a Auth.
                    self.showError(errorMessage: userCreationResult.errorMessage!)
                }
            }
        }
    }
    
    func removeUser(userToRemove: User) -> Void {
        if userToRemove.id != nil {
            self.userBeingRemoved = userToRemove
            self.isDeletingUser = true
        }
    }
    
    func removeUserAndItsImage(userToRemove: User) -> Void {
        let removeUserFromFirestore: ()->Void = {
            self.userVM.removeUser(userId: userToRemove.id!) { error in
                if error != nil {
                    // Error al eliminar usuario.
                    self.showError(errorMessage: "Imposible eliminar al usuario")
                } else {
                    self.users.removeValue(forKey: userToRemove.id!)
                }
            }
        }
        
        if userToRemove.image != nil {
            Task {
                if await self.imageHandler.deleteImage(donwloadUrl: userToRemove.image!) {
                    removeUserFromFirestore()
                } else {
                    self.showError(errorMessage: "Imposible eliminar al usuario")
                }
            }
        } else {
            removeUserFromFirestore()
        }
    }
}
