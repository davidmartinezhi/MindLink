//
//  UserOperationDaat.swift
//  nuevoamanecer
//
//  Created by emilio on 17/10/23.
//

import Foundation
import SwiftUI

struct UserOperationData {
    let userData: User
    let imageToAdd: UIImage?
    let imageToRemove: String?
    let userPassword: String?
    let runAtSuccess: (()->Void)?
    
    init(userData: User, imageToAdd: UIImage? = nil, imageToRemove: String? = nil, userPassword: String? = nil, runAtSuccess: (()->Void)? = nil){
        self.userData = userData
        self.imageToAdd = imageToAdd
        self.imageToRemove = imageToRemove
        self.userPassword = userPassword
        self.runAtSuccess = runAtSuccess
    }
}
