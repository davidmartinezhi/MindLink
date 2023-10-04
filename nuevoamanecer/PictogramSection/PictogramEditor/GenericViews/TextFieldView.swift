//
//  MiscTextFieldView.swift
//  Comunicador
//
//  Created by emilio on 31/05/23.
//

import SwiftUI
import Combine

struct TextFieldView: View {
    var fieldWidth: CGFloat
    var fieldHeight: CGFloat? = nil
    var fontSize: CGFloat = 20
    var placeHolder: String
    var background: Color = Color(red: 0.7, green: 0.7, blue: 0.7)
    @Binding var inputText: String
    var maxCharLength: Int? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            let textField: some View = TextField(placeHolder, text: $inputText)
                .font(.system(size: fontSize))
                .padding()
            
            if maxCharLength != nil {
                textField
                    .onReceive(Just(inputText)) { _ in
                        if inputText.count > maxCharLength! {
                            inputText = String(inputText.prefix(maxCharLength!))
                        }
                    }
            } else {
                textField
            }
            
            if !inputText.isEmpty {
                Button(action: {
                    inputText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .frame(width: fieldWidth, height: fieldHeight)
        .background(background)
        .cornerRadius(10)
    }
}
