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
    var color: Color
    var isDisabled: Bool = false 
    var buttonAction: () -> Void
    
    var body: some View {
        Button(text) {
            buttonAction()
        }
        .padding()
        .foregroundColor(.white)
        .background(!isDisabled ? color : .gray)
        .cornerRadius(5)
        .font(.system(size: textSize, weight: .bold, design: .default))
        .allowsHitTesting(!isDisabled)
    }
}
