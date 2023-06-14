//
//  CustomConfirmAlert.swift
//  nuevoamanecer
//
//  Created by emilio on 14/06/23.
//

import Foundation
import SwiftUI

struct CustomConfirmAlert: ViewModifier {
    var title: String
    var message: String
    @Binding var isPresented: Bool
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                HStack {
                    Button("Confirmar") {
                        action()
                    }
                    
                    Button("Cancelar") {
                        isPresented = false
                    }
                }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func customConfirmAlert(title: String, message: String, isPresented: Binding<Bool>, action: @escaping ()->Void) -> some View {
        self.modifier(CustomConfirmAlert(title: title, message: message, isPresented: isPresented, action: action))
    }
}
