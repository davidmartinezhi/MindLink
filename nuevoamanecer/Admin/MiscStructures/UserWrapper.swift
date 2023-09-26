//
//  UserWrapper.swift
//  nuevoamanecer
//
//  Created by emilio on 23/09/23.
//

import Foundation
import SwiftUI

class UserWrapper: ObservableObject {
    @Published private var user: User?
    
    var id: String? {
        self.user?.id
    }
    
    var name: String? {
        self.user?.name
    }
    
    var email: String? {
        self.user?.email
    }
    
    var isAdmin: Bool? {
        self.user?.isAdmin
    }
    
    var image: String? {
        self.user?.image
    }
    
    init(user: User? = nil){
        self.user = user
    }
    
    func getUser() -> User? {
        return self.user 
    }
    
    func setUser(user: User) -> Void {
        self.user = user
    }
}
