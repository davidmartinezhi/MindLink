//
//  DualTextFieldView.swift
//  nuevoamanecer
//
//  Created by emilio on 26/09/23.
//

import SwiftUI

struct DualTextFieldView: View {
    @Binding var text: String
    var placeholder: String
    var editing: Bool
    var fontSize: CGFloat
    
    var body: some View {
        if editing {
            TextFieldView(fieldWidth: 350, fieldHeight: 35, fontSize: fontSize, placeHolder: placeholder, background: Color(red: 0.8, green: 0.8, blue: 0.8), inputText: $text)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
        } else {
            Text(text)
                .font(.system(size: fontSize))
        }
    }
}
