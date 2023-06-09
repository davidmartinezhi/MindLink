//
//  customAlert.swift
//  Comunicador
//
//  Created by emilio on 03/06/23.
//

import Foundation
import SwiftUI

struct CustomAlert: ViewModifier {
    var title: String
    var message: String
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button("Cerrar") {
                    isPresented = false
                }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func customAlert(title: String, message: String, isPresented: Binding<Bool>) -> some View {
        self.modifier(CustomAlert(title: title, message: message, isPresented: isPresented))
    }
}
