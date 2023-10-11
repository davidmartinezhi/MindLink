//
//  PasswordInputTextField.swift
//  nuevoamanecer
//
//  Created by emilio on 07/10/23.
//

import SwiftUI

enum Field: Hashable {
    case plain
    case secure
}

struct PasswordInputTextFieldView: View {    
    @Binding var password: String
    @State private var showPassword: Bool = false
    @FocusState private var inFocus: Field?
    
    var body: some View {
        ZStack (alignment: .trailing) {
            if showPassword {
                TextField("Contraseña", text: $password)
                    .modifier(PasswordInputTextFieldBaseStyle())
                    .focused($inFocus, equals: .plain)
            } else {
                SecureField("Contraseña", text: $password)
                    .modifier(PasswordInputTextFieldBaseStyle())
                    .focused($inFocus, equals: .secure)
            }
            
            Button() {
                showPassword.toggle()
                inFocus = showPassword ? .plain : .secure
            } label: {
                Image(systemName: showPassword ? "eye" : "eye.slash")
                .padding(.vertical)
                .padding(.trailing)
            }
        }
    }
}

struct PasswordInputTextFieldBaseStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .textInputAutocapitalization(.never)
            .keyboardType(.asciiCapable)
            .autocorrectionDisabled(true)
    }
}
