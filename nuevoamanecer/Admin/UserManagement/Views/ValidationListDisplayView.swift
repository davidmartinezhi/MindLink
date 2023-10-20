//
//  PasswordValidationVieew.swift
//  nuevoamanecer
//
//  Created by emilio on 20/10/23.
//

import SwiftUI

struct ValidationListDisplayView: View {
    let validationList: [String:Bool] // [Regla de validación:estado del cumplimiento de la regla]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(validationList.keys.sorted {$0 < $1}), id: \.self){ key in
                HStack{
                    Image(systemName: validationList[key]! ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(validationList[key]! ? .green : .red)
                    Text(key)

                }
                Divider()
            }
        }
    }
}
