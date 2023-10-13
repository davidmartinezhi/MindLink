//
//  MiscButton.swift
//  Comunicador
//
//  Created by emilio on 28/05/23.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var textSize: CGFloat = 15
    var padding: CGFloat = 10 
    var color: Color
    var isDisabled: Bool = false 
    var buttonAction: () -> Void
    
    var body: some View {
        Button(text) {
            buttonAction()
        }
        .padding(10)
        .background(!isDisabled ? color : .gray)
        .foregroundColor(.white)
        .cornerRadius(10)
        .font(.system(size: textSize, weight: .regular, design: .default))
        .allowsHitTesting(!isDisabled)
    }
}
