//
//  DismissView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 16/05/23.
//

import SwiftUI

struct DismissView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack{
            
            Spacer()
            Button("Cerrar"){
                dismiss()
            }
            .tint(.black)
            .padding(.trailing)
        }
        .buttonStyle(.bordered)
    }
}

struct DismissView_Previews: PreviewProvider {
    static var previews: some View {
        DismissView()
    }
}
