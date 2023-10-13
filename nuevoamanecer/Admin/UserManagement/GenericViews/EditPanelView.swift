//
//  EditPanelView.swift
//  nuevoamanecer
//
//  Created by emilio on 29/09/23.
//

import SwiftUI

struct EditPanelView: View {
    var isBeingEdited: Bool
    var isNewUser: Bool
    var disableSave: Bool
    var runAtEdit: ()->Void
    var runAtDelete: ()->Void
    var runAtSave: ()->Void
    var runAtCancel: ()->Void
    
    var body: some View {
        if isBeingEdited {
            isBeingEditedPanel
        } else {
            isNotBeingEditedPanel
        }
    }
    
    var isNotBeingEditedPanel: some View {
        HStack(spacing: 40){
            //let iconWidth: CGFloat = 25

            Button {
                runAtEdit()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)  // Cuadrado con bordes redondeados
                        .stroke(lineWidth: 2)  // Borde del cuadrado
                        .frame(width: 40, height: 40)  // Dimensiones del cuadrado
                        .background(.blue)
                        .foregroundColor(.blue)
                    Image(systemName: "pencil")  // Icono de basura
                        .resizable()  // Hacer que el icono sea redimensionable
                        .scaledToFit()  // Escalar el icono para que encaje dentro del cuadrado
                        .frame(width: 25, height: 25)  // Dimensiones del icono
                        .foregroundColor(.white)
                }
            }
            .cornerRadius(10)
            
            
            Button {
                runAtDelete()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)  // Cuadrado con bordes redondeados
                        .stroke(lineWidth: 2)  // Borde del cuadrado
                        .frame(width: 40, height: 40)  // Dimensiones del cuadrado
                        .background(.red)
                        .foregroundColor(.red)
                    Image(systemName: "trash")  // Icono de basura
                        .resizable()  // Hacer que el icono sea redimensionable
                        .scaledToFit()  // Escalar el icono para que encaje dentro del cuadrado
                        .frame(width: 25, height: 25)  // Dimensiones del icono
                        .foregroundColor(.white)
                }
            }
            .cornerRadius(10)
        }
    }
    
    var isBeingEditedPanel: some View {
        VStack(spacing: 10) {
            ButtonWithImageView(text: "Guardar", width: 150, systemNameImage: "square.and.arrow.down", isDisabled: disableSave){
                runAtSave()
            }
            
            ButtonWithImageView(text: "Cancelar", width: 150, systemNameImage: "xmark", background: .red){
                runAtCancel()
            }
        }
    }
}
