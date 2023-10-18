//
//  UserManagementExtensions.swift
//  nuevoamanecer
//
//  Created by emilio on 10/10/23.
//

import Foundation
import SwiftUI

extension UserManagement {
    func addUser(userToAdd: User, withImage: UIImage?, withPassword: String) -> Void {
        executeWithPasswordConfirmation = { currUserPassword in
            let addUserToFirestore: (User)->Void = { user in
                self.userVM.addUserWithCustomId(user: user, userId: user.id!) { error in
                    if error != nil{
                        // Error al añadir usuario.
                        self.showError(errorMessage: "La creación del usuario no fue exitosa")
                    } else {
                        self.users[user.id!] = user
                        self.userBeingEdited = nil
                        self.creatingUser = false
                    }
                }
            }
            
            Task {
                if withImage != nil {
                    if let userWithImage: User = await self.addImageToUser(user: userToAdd, image: withImage!) {
                        if let userWithAuthId: User = await self.addUserToAuth(user: userWithImage, withPassword: withPassword, currUserPassword: currUserPassword) {
                            addUserToFirestore(userWithAuthId)
                        } else {
                            self.showError(errorMessage: "La creación del usuario no fue exitosa")
                        }
                    } else {
                        self.showError(errorMessage: "No fue posible cargar la imagén del usuario")
                    }
                } else {
                    if let userWithAuthId: User = await self.addUserToAuth(user: userToAdd, withPassword: withPassword, currUserPassword: currUserPassword) {
                        addUserToFirestore(userWithAuthId)
                    } else {
                        self.showError(errorMessage: "La creación del usuario no fue exitosa")
                    }
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
    
    func editUser(userToEdit: User, withImage: UIImage?, removingImage: String?, runAtSuccessfulEdit: (()->Void)?) -> Void {
        let editUserFromFirestore: (User)->Void = { user in
            self.userVM.editUser(userId: user.id!, newUserValue: user) { error in
                if error != nil {
                    self.showError(errorMessage: "Error al guardar los cambios")
                    return
                } else {
                    if runAtSuccessfulEdit != nil {
                        runAtSuccessfulEdit!()
                    }
                    self.userBeingEdited = nil
                    self.users.removeValue(forKey: user.id!)
                    self.users[user.id!] = user
                }
            }
        }
        
        Task {
            if withImage != nil {
                if let userWithImage: User = await self.replaceUserImage(user: userToEdit, image: withImage!){
                    editUserFromFirestore(userWithImage)
                } else {
                    self.showError(errorMessage: "Error al guardar al nueva imagén del usuario")
                }
            } else {
                editUserFromFirestore(userToEdit)
            }
            
            if removingImage != nil {
                _ = await self.imageHandler.deleteImage(donwloadUrl: removingImage!)
            }
        }
    }
    
    func _removeUser(userToRemove: User) -> Void {
        let removeUserFromFirestore: (User)->Void = { user in
            self.userVM.removeUser(userId: user.id!) { error in
                if error != nil {
                    // Error al eliminar usuario.
                    self.showError(errorMessage: "Imposible eliminar al usuario")
                } else {
                    self.users.removeValue(forKey: user.id!)
                }
            }
        }
        
        if userToRemove.image != nil {
            Task {
                if let userWithoutImage: User = await self.removeImageFromUser(user: userToRemove) {
                    removeUserFromFirestore(userWithoutImage)
                } else {
                    self.showError(errorMessage: "Imposible eliminar al usuario")
                }
            }
        } else {
            removeUserFromFirestore(userToRemove)
        }
    }
    
    // Image operations:
    private func addImageToUser(user: User, image: UIImage) async -> User? {
        var userWithImage: User = user
        if let imageUrl: URL = await self.imageHandler.uploadImage(image: image, name: buildUserImageName(user: userWithImage)) {
            userWithImage.image = imageUrl.absoluteString
            return userWithImage
        }
        return nil
    }
    
    private func removeImageFromUser(user: User) async -> User? {
        var userWithoutImage: User = user
        if await self.imageHandler.deleteImage(donwloadUrl: user.image!) {
            userWithoutImage.image = nil
            return userWithoutImage
        }
        return nil
    }
    
    private func replaceUserImage(user: User, image: UIImage) async -> User? {
        if user.image != nil {
            if let userWithoutImage: User = await self.removeImageFromUser(user: user) {
                return await self.addImageToUser(user: userWithoutImage, image: image)
            }
            return nil
        } else {
            return await self.addImageToUser(user: user, image: image)
        }
    }
    
    // Auth operations:
    private func addUserToAuth(user: User, withPassword: String, currUserPassword: String) async -> User? {
        var userWithAuthId: User = user
        
        let userCreationResult: AuthActionResult = await self.authVM.createNewAuthAccount(email: user.email, password: withPassword, currUserPassword: currUserPassword)
        
        if userCreationResult.success  {
            userWithAuthId.id = userCreationResult.userId!
            return userWithAuthId
        }
        return nil
    }
}
