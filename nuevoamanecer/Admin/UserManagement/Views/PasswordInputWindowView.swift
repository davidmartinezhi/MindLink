//
//  UserPasswordInputView.swift
//  nuevoamanecer
//
//  Created by emilio on 08/10/23.
//

import SwiftUI

struct PasswordInputWindowView: View {
    @Binding var action: ((String)->Void)?
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("Ingrese su contraseña")
            
            PasswordInputTextFieldView(password: $password)
            
            HStack {
                ButtonView(text: "Confirmar", color: .blue, isDisabled: !password.isValidPassword() || action == nil) {
                    action!(password)
                }
                
                ButtonView(text: "Cancelar", color: .gray) {
                    action = nil
                }
            }
        }
    }
}
