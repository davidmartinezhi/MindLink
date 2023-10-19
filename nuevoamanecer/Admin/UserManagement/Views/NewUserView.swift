//
//  NewUserView.swift
//  nuevoamanecer
//
//  Created by emilio on 18/10/23.
//

import SwiftUI

struct NewUserView: View {
    @State var newUser: User = User.newEmptyUser()
    @Binding var userBeingEdited: String?
    var makeUserOperation: (UserOperation, UserOperationData) -> Void
    
    var body: some View {
        UserView(user: $newUser, userBeingEdited: $userBeingEdited, makeUserOperation: makeUserOperation)
    }
}
