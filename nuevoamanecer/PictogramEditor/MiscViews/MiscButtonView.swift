//
//  MiscButton.swift
//  Comunicador
//
//  Created by emilio on 28/05/23.
//

import SwiftUI

struct MiscButtonView: View {
    var text: String
    var color: Color
    var textSize: CGFloat = 15
    var buttonAction: () -> Void
    
    var body: some View {
        Button(text) {
            buttonAction()
        }
        .padding()
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(5)
        .font(.system(size: textSize, weight: .bold, design: .default))
    }
}
