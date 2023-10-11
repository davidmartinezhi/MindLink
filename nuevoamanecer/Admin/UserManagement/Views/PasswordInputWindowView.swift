//
//  UserPasswordInputView.swift
//  nuevoamanecer
//
//  Created by emilio on 08/10/23.
//

import SwiftUI

struct PasswordInputWindowView: View {
    @EnvironmentObject var currentUser: UserWrapper
    
    @Binding var action: ((String)->Void)?
    @State private var password: String = ""
    let width: CGFloat = 400
    let height: CGFloat = 200
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.black)
                .frame(width: width + 1, height: height + 1)
            
            
            VStack(spacing: 20) {
                let currentUserName: String = currentUser.name != nil ? "(\(currentUser.name!)" : ""
                Text("Ingrese su contraseña" + currentUserName)
                    .bold()
                
                PasswordInputTextFieldView(password: $password)
                
                HStack (spacing: 10) {
                    ButtonView(text: "Confirmar", color: .blue, isDisabled: !password.isValidPassword() || action == nil) {
                        action!(password)
                        action = nil
                    }
                    
                    ButtonView(text: "Cancelar", color: .gray) {
                        action = nil
                    }
                }
            }
            .padding()
            .frame(width: width, height: height)
            .background(.white)
            .cornerRadius(10)
        }
    }
}
