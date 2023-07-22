//
//  MiscTextFieldView.swift
//  Comunicador
//
//  Created by emilio on 31/05/23.
//

import SwiftUI

struct TextFieldView: View {
    var fieldWidth: Double
    var placeHolder: String
    var background: Color = Color(red: 0.9, green: 0.9, blue: 0.9)
    @Binding var inputText: String
    
    var body: some View {
        HStack(spacing: 0) {
            TextField(placeHolder, text: $inputText)
                .font(.system(size: 20))
                .padding()
            
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
        .frame(width: fieldWidth)
        .background(background)
        .cornerRadius(10)
    }
}
